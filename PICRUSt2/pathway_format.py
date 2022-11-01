#!/usr/bin/env python3

# Do the imports
import re
import sys
import getopt

def main():
    
    acc_list_file=""
    path_abun=""
    
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
            path_abun = str(arg)
        if opt == "-o":
            path_abun_formated = str(arg)
    
    
    sample_dic = {}
    with open(acc_list_file) as a:
        line = a.readline()
        line = a.readline()
        for line in a:
            split_line = line.split('\t')
            key = split_line[0]
            val = str(split_line[1]).strip()
            sample_dic[str(key)] = val

    fileIn = open(path_abun, "r")
    fileOut = open(path_abun_formated, "w")

    line = fileIn.readline()

    while (line):
        if str(line).startswith('pathway'):
            sample_id = ""
            sample_type = ""
            output = ""
            sample_list = str(line).split('\t')
            for x in sample_list:
                sample_type = sample_dic.get(str(x).strip())
                output += str(sample_type).strip() + "\t"
            output = output.replace("None", "type")
            modified = str(line).replace("pathway", "ID")
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
