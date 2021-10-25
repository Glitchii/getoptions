#!/bin/bash

getoption() {
    opts=("$@")
    
    if [[ ! $1 =~ ^--? ]]; then
        echo "Missing parameter and variable name. Example: getoption --text value" >&1
        return 1
    fi
    
    if [[ -z $2 ]]; then
        echo "Missing variable name. Example: getoption $1 value. The variable name holds the value of the parameter" >&1
        return 1
    fi

    shortparamname=${1#-}
    for i in "${!opts[@]}"; do
        opt="${opts[$i]}" next="${opts[$i + 1]}"
        # Full word parameters (--)
        if [[ $opt =~ ^$1$ ]]; then
            [[ $next =~ ^--?[^-] ]] && eval $2='' || eval $2=\'$next\'
            [[ -n $3 ]] && eval $3=true
            return 0
        # short parameters (-)
        elif [[ $opt =~ ^-[^-] && $opt =~ ^-[a-zA-Z]*$shortparamname[a-zA-Z]*$ ]]; then
            [[ $next =~ ^--?[^-] ]] && eval $2='' || eval $2=\'$next\'
            [[ -n $3 ]] && eval $3=true
            return 0
        fi

        [[ -n $3 ]] && eval $3=false
    done
}

# Examples:
# Run: 'bash main.sh -abc alphabet -de --greet Hello world --text "Lorem ipsum" -x y --empty'
# Results after running above

getoption -a value
echo $value             # alphabet

getoption -b value
echo $value             # alphabet

getoption --greet whatever
echo $whatever          # Hello

getoption --text value
echo $value             # Lorem ipsum

getoption --empty value
echo $value             # 

# The value argment will most likely be an empty string in both situations when a parameter is defined with no value, or is not defined at all.
# To know if a parameter is defined in either with or with no value, pass another argument to the function.
# The parameter will be replaced with true if the parameter is defined and false otherwise.
# Example:

getoption --text value defined
echo $defined            # true

getoption --notDefined value defined
echo $defined            # false

getoption --empty value defined
echo $defined            # true

# Add line 3 to 33 to bashrc so you can use without sourcing or putting directly into code.
# getoption is supposed to be used a bash file, not on the command line.
