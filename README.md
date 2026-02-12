[![CI](https://github.com/tseemann/cgmlst-dists/actions/workflows/CI.yml/badge.svg)](https://github.com/tseemann/cgmlst-dists/actions/workflows/CI.yml)
[![License: GPLv3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Language: C99](https://img.shields.io/badge/Language-ANSI_C-orangered.svg)](https://en.wikipedia.org/wiki/ANSI_C)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/tseemann/cgmlst-dists)](https://github.com/tseemann/cgmlst-dists/releases)
[![Bioconda downloads](https://img.shields.io/conda/dn/bioconda/cgmlst-dists)](https://bioconda.github.io/recipes/cgmlst-dists/README.html)
[![Google Scholar citations](https://img.shields.io/badge/citations-Google_Scholar-4285F4?logo=google-scholar)](https://scholar.google.com/scholar?q=%22cgmlst-dists%22+tseemann+github)

# cgmlst-dists

Calculate distance matrix from 
cgMLST allele call tables of ChewBBACA

## Quick Start

```
% cat test/boring.tab

FILE    G1      G2      G3      G4      G5      G6
S1      1       INF-2   3       2       1       5
S2      1       1       1       1       NIPH    5
S3      1       2       3       4       1       3
S4      1       LNF     2       4       1       3
S5      1       2       ASM     2       1       3
S6      2       INF-8   3       PLOT3   PLOT5   3     

% cgmlst-dists test/boring.tab > distances.tab

This is cgmlst-dists 0.4.0
Loaded 6 samples x 6 allele calls
Calulating distances... 100.00%
Done.

% cat distances.tab

        S1      S2      S3      S4      S5
S1      0       3       2       3       1
S2      3       0       4       3       3
S3      2       4       0       1       1
S4      3       3       1       0       1
S5      1       3       1       1       0
S6      3       4       2       2       2
```

Any allelle calls that are not positive integers are converted to zero.
The distance is the 
[hamming distance](https://en.wikipedia.org/wiki/Hamming_distance)
but with zeroes excluded.

It works by replacing any alphabet characters,
and the strings `PLOT5` and `PLOT3` with spaces.
It then converts the remaining tab separated
values to integers and ignoring negative signs.
Anything weird is set to zero.

## Installation

```
conda install -c bioconda cgmlst-dists
```

## Options

### `cgmlst-dists -h` (help)

```
SYNOPSIS
  Pairwise CG-MLST distance matrix from allele call tables
USAGE
  cgmlst-dists [options] chewbbaca.tab > distances.tsv
OPTIONS
  -h	Show this help
  -v	Print version and exit
  -q	Quiet mode; do not print progress information
  -j N	Use this many CPU threads [1]
  -c	Use comma instead of tab in output
  -m N	Output: 1=lower-tri 2=upper-tri 3=full [3]
  -x N	Stop calculating beyond this distance [999]
URL
  https://github.com/tseemann/cgmlst-dists
```

### `cgmlst-dists -v` (version)

Prints the name and version separated by a space in standard Unix fashion.

```
cgmlst-dists 0.4.0
```

### `cgmlst-dists -j CPUS)

Use multiple threads to compute the distance matrix.
This gives a linear speed-up in the number of threads.

### `cgmlst-dists -q` (quiet mode)

Don't print informational messages, only errors.

### `cgmlst-dists -c` (CSV mode)

Use a comma instead of a tab in the output table.

### `cgmlst-dists -m N` (output matrix format)

The output matrix is diagonal symmetric because _dist(A,B)=dist(B,A)_.
This means we only calculate half the matrix and mirror it.
You can choose to output the lower triangle, upper triangle, or both:
* `-m 1` lower triangle only
* `-m 2` upper triangle only
* `-m 3` both triangle / full matrix (default)

### `cgmlst-dists -x N` (short-circuit divergent pairs)

The slowest part of the algorithm is calculating the distance
between two allele vectors. This option will stop comparing as
soon as the distance (differences) exceeds `-x`, and return
the distance as `-x`.

## Issues

Report bugs and give suggesions on the
[Issues page](https://github.com/tseemann/cgmlst-dists/issues)

## Related software

* [Distle](https://github.com/KHajji/distle)
* [NiST](https://github.com/BioinformaticsPlatformWIV-ISP/MiST)
* [chewBBACA](https://github.com/B-UMMI/chewBBACA)
* [snp-dists](https://github.com/tseemann/snp-dists)

## Licence

[GPL Version 3](https://raw.githubusercontent.com/tseemann/cgmlst-dists/master/LICENSE)

## Authors

* [Torsten Seemann](https://tsee,amm.github.io)
