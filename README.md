# Boundary Condition Removal Script

This script is designed to remove periodic boundary conditions from .gro or .xtc files obtained from GROMACS simulations. It processes these files to handle specific boundary conditions and prepare them for further analysis.

## Usage
``` tcsh
./centralize.tcsh [-single filename] [-all]
```
## Options

`-single filename`: Specifies a single file to process. The file must have a .gro or .xtc extension.
`-all`: Processes all files in the current directory. This flag does not require additional arguments.

## Examples

### Processing a Single File:

``` tcsh
./centralize.tcsh -single file.gro
```

This command will process the specified .gro file.

### Processing All Files:

``` tcsh
./centralize.tcsh -all
```

This command will process all .gro or .xtc files in the current directory.

## Notes

Ensure that the file specified with the `-single` flag has a `.gro` or `.xtc` extension.
The script only accepts one flag at a time. Passing both `-single` and `-all` will result in a warning and exit.

## Troubleshooting

If you encounter issues, make sure that GROMACS and the required utilities (tcsh, awk, sed, seq) are properly installed and accessible in your environment.
