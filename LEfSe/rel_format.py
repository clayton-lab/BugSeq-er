#!/usr/bin/env python3

# Do the imports
import re
import sys
import getopt

def main():
    
    acc_list_file=""
    rel_level_file=""
    
    # Read in the command-line arguments into the opts list.
    try:
        opts, args = getopt.getopt(sys.argv[1:], "i:r:o:")
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
        if opt == "-r":
            rel_level_file = str(arg)
        if opt == "-o":
            rel_level_file_formated = str(arg)
    
    
    sample_dic = {}
    with open(acc_list_file) as a:
        line = a.readline()
        line = a.readline()
        for line in a:
            split_line = line.split('\t')
            key = split_line[0]
            val = split_line[1]
            sample_dic[str(key)] = val
    
    fileIn = open(rel_level_file, "r")
    fileOut = open(rel_level_file_formated, "w")

    line = fileIn.readline()
    line = fileIn.readline()

    while (line):
        
        if str(line).startswith('#OTU'):
            sample_id = ""
            sample_type = ""
            output = ""
            sample_list = str(line).split('\t')
            for x in sample_list:
                sample_type = sample_dic.get(str(x).strip())
                output += str(sample_type).strip() + "\t"
            modified = str(line).replace("#OTU ID", "ID")
            output = output.replace("None", "type")
            output = output.strip() 
            output += "\n"
            fileOut.write(output)
            fileOut.write(modified)
            line = fileIn.readline()
        else:
            fileOut.write(str(line))
            line = fileIn.readline()
    fileOut.close()
                
if __name__ == '__main__':
    main()
