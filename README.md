# Toolchain-iverilog

## Introduction

[Apio](https://github.com/FPGAwars/apio) package for verify and simulate the verilog code using [Icarus Verilog](http://iverilog.icarus.com/)

## Usage

Edit the target architectures in the `build.sh` script:

```
# -- Target architectures
ARCHS=( linux_x86_64 linux_armv7l )
# ARCHS=( linux_x86_64 linux_i686 linux_armv7l linux_aarch64 windows )
# ARCHS=( darwin )
```

Run the script `./build.sh`

Final packages will be generated in **\_packages/build_ARCH/** directory.

## Authors

* [Jesús Arroyo Torrens](https://github.com/Jesus89)

## License

Licensed under a GPL v2 and [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/)
