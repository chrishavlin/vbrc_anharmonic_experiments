# vbrc_anharmonic_experiments

This repository demonstrates how to calculate and set the anharmonic moduli input
to the [VBRc](https://vbr-calc.github.io/vbr/). The anharmonic calculation uses
the MATLAB methods from Abers & Hacker (2016)

There are two `.m` files: 
* `vbrc_with_abers_hacker_anharmonic.m` : the main script 
* `calculate_unrelaxed_moduli_density.m` : a function for calculating moduli and density (where the Abers & Hacker calculation happens).

For a more detailed description, see the blog post [here](https://chrishavlin.github.io/post/vbrc_moduli/).

## Requirements & Setup 

The code here requires a somewhat recent MATLAB or GNU Octave installation.

Additionally, there are three setup steps:

### 1. Download or Clone this repository 

Download the whole repository as a zip file and unpack it. Or 

```shell
$ git clone https://github.com/chrishavlin/vbrc_anharmonic_experiments
```

### 2. setup VBRc

This code requires the VBRc with version >= v1.1.0. See [VBRc installation instructions](https://vbr-calc.github.io/vbr/gettingstarted/installation/). 

The main script, `vbrc_with_abers_hacker_anharmonic.m` checks for an environment variable, 
`vbrdir` that points to the directory where you installed the VBRc. You can either change 
that line in `vbrc_with_abers_hacker_anharmonic.m` or set that environment variable after 
downloading the VBRc. In bash, you can set an environment variable with 

```shell
export vbrdir=/the/path/to/you/VBRc/installation
```

or, after starting MATLAB or GNU Octave, 

```shell
setenv('vbrdir', '/the/path/to/you/VBRc/installation')
```

### Fetching Abers & Hacker code

This repository does not include a copy of the Abers & Hacker code, so you'll 
need to: 

1. Download and unpack the supplemental zip file from Abers & Hacker 2016. Here's a [direct link](https://agupubs.onlinelibrary.wiley.com/action/downloadSupplement?doi=10.1002%2F2015GC006171&file=ggge20945-sup-0001-2015GC006171-s01.zip). If the direct link dies, you should be able to access the supplemental materials via the paper, [doi:10.1002/2015GC006171](https://doi.org/10.1002/2015GC006171).
2. After unpacking the zip file, copy the `ABERSHACKER16` subdirectory to this directory. Alternatively, you can instead modify the line in `vbrc_with_abers_hacker_anharmonic.m` that adds `ABERSHACKER16` to the MATLAB path.

## References

Abers, G. A., and B. R. Hacker (2016), A MATLAB toolbox and Excel workbook for 
calculating the densities, seismic wave speeds, and major element composition of 
minerals and rocks at pressure and temperature, Geochem. Geophys. Geosyst., 17, 
616–624, [doi:10.1002/2015GC006171](https://doi.org/10.1002/2015GC006171). 

## LICENSE note

The code in **this** repository is licensed with an MIT open source license. The Abers & Hacker 
code is freely available via the links above but not explicitly licensed (and so was not included 
in **this** repository.)
