An alternative to the builtin '`getopts`', but better.

# Usage examples:
```bash
bash test.sh --text "Lorem ipsum" anythingelse -x y

# Now, inside test.sh
# Get the value of --text from the command above
getoption --text value
echo $value             # Lorem ipsum

# Get the value of x
getoption -x value
echo $value             # y
```
More examples in main.sh.
