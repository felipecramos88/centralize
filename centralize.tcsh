#!/usr/bin/tcsh

# Check if the number of arguments is less than 1
if ( "$#" < 1 ) then
    echo "Usage: $0 [-single filename] [-all]"
    exit 1
endif

# Initialize flags
set flag_single = 0
set flag_all = 0
set filename = ""

# Loop through the passed arguments
set i = 1
while ( $i <= $#argv )
    switch ( $argv[$i] )
        case '-single':
            set flag_single = 1
            @ i++
            if ( $i <= $#argv ) then
                set filename = $argv[$i]  # Get the next argument as the filename
            else
                echo "Error: '-single' requires a filename as the next argument."
                echo "Usage: $0 [-single filename] [-all]"
                exit 1
            endif
            breaksw

        case '-all':
            set flag_all = 1
            breaksw

        default:
            echo "Invalid option: $argv[$i]"
            echo "Usage: $0 [-single filename] [-all]"
            exit 1
            breaksw
    endsw
    @ i++
end

# Check for valid file extension if '-single' is used
if ( $flag_single == 1 && "$filename" != "" ) then
    if ( "$filename" =~ *.gro || "$filename" =~ *.xtc ) then
        echo "The '-single' flag was passed, processing the file: $filename"

	set FILE = `echo $filename`
        set NAME = `echo $filename | cut -d '.' -f1`
        set TYPE = `echo $filename | cut -d '.' -f2`

        echo "Centering on the protein and extracting the entire system:"
	echo 1 0 | gmx_mpi trjconv -s ${NAME}.tpr -f $FILE -o ${NAME}_c.${TYPE} -ur compact -pbc mol -center

        # echo "Centering on the protein and extracting only the protein:"
        # echo 1 1 | gmx_mpi trjconv -s min.tpr -f $FILE -o ${NAME}_Protein_c.${TYPE} -ur compact -pbc mol -center

        # echo "Centering on the protein and extracting everything but the water molecules:"
        # echo 1 17 | gmx_mpi trjconv -s min.tpr -f $FILE -o ${NAME}_non-Water_c.${TYPE} -ur compact -pbc mol -center

    else
        echo "Error: The file specified with '-single' must be a .gro or .xtc file."
        exit 1
    endif
endif

# Handle the '-all' flag
if ( $flag_all == 1 ) then
    echo "The '-all' flag was passed, processing all files."

    set list = (`ls -1 *.gro | grep -v "_c" && ls -1 *.xtc | grep -v "_c"`)

    foreach FILE ( $list )

      set NAME = `echo $FILE | cut -d '.' -f1`
      set TYPE = `echo $FILE | cut -d '.' -f2`

      echo $NAME
      echo $TYPE

      # Centering on the protein and extracting the entire system:
      echo 1 0 | gmx_mpi trjconv -s {$FILE}.tpr -f $FILE -o ${NAME}_c.${TYPE} -ur compact -pbc mol -center

      # echo "Centering on the protein and extracting only the protein:"
      # echo 1 1 | gmx_mpi trjconv -s min.tpr -f $FILE -o ${NAME}_Protein_c.${TYPE} -ur compact -pbc mol -center

      # echo "Centering on the protein and extracting everything but the water molecules:"
      # echo 1 17 | gmx_mpi trjconv -s min.tpr -f $FILE -o ${NAME}_non-Water_c.${TYPE} -ur compact -pbc mol -center

    end

endif

# Check for conflicting flags
if ( $flag_single == 1 && $flag_all == 1 ) then
    echo "Warning: You passed both '-single' and '-all' flags, please use only one."
    exit 1
endif

echo "End of script"
