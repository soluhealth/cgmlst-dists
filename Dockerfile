# Minimal cgmlst-dists image: a single C binary that computes a pairwise
# distance matrix from a ChewBBACA cgMLST allele-call table.
#
# Two stages so the final image carries only the binary and the OpenMP runtime,
# not the toolchain. Both stages share the same glibc base (debian:bookworm-slim)
# so the binary built in stage 1 is ABI-compatible with stage 2.

FROM debian:bookworm-slim AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc make libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY Makefile main.c ./
# `make install` puts the binary at $PREFIX/bin/cgmlst-dists. CFLAGS already
# carries -fopenmp via the Makefile, so we don't re-specify it here.
RUN make && make install PREFIX=/usr/local

# ---

FROM debian:bookworm-slim

# libgomp1 = OpenMP runtime (libgomp.so.1). Required because main.c uses
# omp_set_num_threads / #pragma omp parallel for and the binary is linked
# with -fopenmp.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/cgmlst-dists /usr/local/bin/cgmlst-dists

# Callers bind-mount their input table into /data and reference it by relative
# path: `docker run --rm -v "$PWD:/data" IMAGE chewbbaca.tab > distances.tsv`.
WORKDIR /data

ENTRYPOINT ["cgmlst-dists"]
