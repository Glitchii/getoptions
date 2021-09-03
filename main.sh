#!/bin/bash

opts=("$@")
arg1description="The first argument is the parameter name; it should either start with '--' followed with the param named or start with '-' followed with a short one-letter param named."
arg2description="The second argument given to the function will contain the parameter (or empty if no value) after the function is called."

getoptions() {
    if [[ ! $1 =~ ^--? ]]; then
        echo $arg1description >&1
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

getoptions -a value
echo $value             # alphabet

getoptions -b value
echo $value             # alphabet

getoptions --greet whatever
echo $whatever          # Hello

getoptions --text value
echo $value             # Lorem ipsum

getoptions --empty value
echo $value             # 

# The value argment will most likely be an empty string in both situations when a parameter is defined with no value, or is not defined at all.
# To know if a parameter is defined in either with or with no value, pass another argument to the function.
# The parameter will be replaced with true if the parameter is defined and false otherwise.
# Example:

getoptions --text value defined
echo $defined            # true

getoptions --notDefined value defined
echo $defined            # false

getoptions --empty value defined
echo $defined            # true