#!/usr/bin/env python3

# Do the imports
import re
import sys
import getopt

def main():
    acc_list_file=""#'acc_list.txt'

    path = ""

    # Read in the command-line arguments into the opts list.
    try:
        opts, args = getopt.getopt(sys.argv[1:], "i:p:")
    except getopt.GetoptError as err:
        
        # Redirect STDERR to STDOUT (insures screen display)
        sys.stdout = sys.stderr

        # Print help information
        print(str(err))

        # Print usage information; usage() is the name of a
        # function (declared elsewhere) that displays usage 
        # information (just a series of print statements).
        usage()

        # Exit the program
        sys.exit(2)
            
    # Process the opt and arg lists displaying the argument of
    # each option.
    for (opt, arg) in opts:
        if opt == "-i":
            acc_list_file = str(arg)
        if opt == "-p":
            path = str(arg)
    
    fileIn = open(acc_list_file, "r")
    line = fileIn.readline()

    with open("manifest", "w") as out:
        out.write("sample-id\tforward-absolute-filepath\treverse-absolute-filepath\n")
        while (line):
            sample_id = ""
            output = ""
            sample_id = str(line).strip()
            forward_path = path + "/" + sample_id + "_1.fastq"
            reverse_path = path + "/" + sample_id + "_2.fastq"
            output = sample_id + "\t" + forward_path + "\t" + reverse_path + "\n"
            out.write(output)
            line = fileIn.readline()

if __name__ == '__main__':
    main()
