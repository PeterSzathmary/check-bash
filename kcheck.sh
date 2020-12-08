#!/bin/bash

# how to use this script
#
#           -u calls function check_user
#           -p calls function check_permission
#           -d calls function check_directory
#
# EXAMPLES:
# kcheck.sh -u [NAME_OF_THE_USER]
# kcheck.sh -p [FILE | FULL_PATH_TO_FILE]
# kcheck.sh -d [DIRECTORY | FULL_PATH_TO_DIRECTORY]

# Regular Colors
Black="\033[0;30m"  # Black
Red="\033[0;31m"  # Red
Green="\033[0;32m"  # Green
Yellow="\033[0;33m"  # Yellow
Light_Yellow="\033[0;93m"  # Light Yellow
Blue="\033[0;34m"  # Blue
Light_Blue="\033[0;94m" # Light Blue
Purple="\033[0;35m"  # Purple
Cyan="\033[0;36m"  # Cyan
Light_Cyan="\033[0;96m"  # Light Cyan
White="\033[0;37m"  # White

# Background
On_Black="\033[40m"  # Black
On_Red="\033[41m"  # Red
On_Green="\033[42m"  # Green
On_Yellow="\033[43m"  # Yellow
On_Blue="\033[44m"  # Blue
On_Purple="\033[45m"  # Purple
On_Cyan="\033[46m"  # Cyan
On_White="\033[47m"  # White

# Reset
Reset="\033[0;0m"

check_user () {
    #echo -e "user: $1"
    if id -u "$1" >/dev/null 2>&1; then
        echo -e "${Light_Yellow}${1^^}${Reset} lives in: $(eval echo ~$1)"
        echo -e "Fellowship ${Light_Yellow}${1^^}${Reset} is taking part in: "
        groups "$1"
    else
        echo -e "${Red}${1^^} is nowhere to be found!${Reset}"
    fi
}

check_permission () {

    PASSED=$1

    export VAR=$1
    export DIR=${VAR%/*}

    # directory
    if [ -d "${PASSED}" ]; then
        echo "input is a directory"
    # file
    elif [ -f "${PASSED}" ]; then

        echo "input is a file"

        if [[ "$DIR" = /* ]]; then

            #echo "ABSOLUTE"

            file=${VAR##*/}

            ls -l "$DIR/${file}" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                fileInfo=$(ls -l "$DIR/${file}")

                echo "FILE: $file"
                echo "FILE PATH: $DIR"

                echo -e "\nFILE INFO: $fileInfo\n"
                echo -e "OWNER\t\t->\t$(stat -c '%U' $DIR/${file})\t->\tpermissions: ${Light_Cyan}${fileInfo:1:3}${Reset}"
                echo -e "GROUP\t\t->\t$(stat -c '%G' $DIR/${file})\t->\tpermissions: ${Light_Cyan}${fileInfo:4:3}${Reset}"
                echo -e "OTHER USERS\t->\t->\t->\t->\tpermissions: ${Light_Cyan}${fileInfo:7:3}${Reset}"
            else
                echo -e "${Red}No such file or directory${Reset}"
            fi
        else

            #echo "RELATIVE"

            ls -l "$1" > /dev/null 2>&1
            if [ $? -eq 0 ]; then

                file=$1
                fileInfo=$(ls -l "$1")

                echo "FILE: $file"
                echo "FILE PATH: $(pwd)"

                echo -e "\nFILE INFO: $fileInfo\n"
                echo -e "OWNER\t\t->\t$(stat -c '%U' ${file})\t->\tpermissions: ${Light_Cyan}${fileInfo:1:3}${Reset}"
                echo -e "GROUP\t\t->\t$(stat -c '%G' ${file})\t->\tpermissions: ${Light_Cyan}${fileInfo:4:3}${Reset}"
                echo -e "OTHER USERS\t->\t->\t->\t->\tpermissions: ${Light_Cyan}${fileInfo:7:3}${Reset}"
            else
                echo -e "${Red}No such file or directory${Reset}"
            fi
        fi
    else
        echo -e "${Red}No such file or directory${Reset}"
    fi
}

check_directory () {
    echo -e "directory: $1"
}

if [ $1 = "-u" ]; then
    echo -e "${Green}-----------------------------------------------------------${Reset}"
    echo -e "\nfunction: check_user"
    check_user $2
    echo -e "\n${Green}-----------------------------------------------------------${Reset}\n"
elif [ $1 = "-p" ]; then
    echo -e "${Green}-----------------------------------------------------------${Reset}"
    echo -e "\nfunction: check_permission"
    check_permission $2
    echo -e "\n${Green}-----------------------------------------------------------${Reset}\n"
elif [ $1 = "-d" ]; then
    echo -e "${Green}-----------------------------------------------------------${Reset}"
    echo -e "\nfunction: check_directory"
    check_directory $2
    echo -e "\n${Green}-----------------------------------------------------------${Reset}\n"
fi
