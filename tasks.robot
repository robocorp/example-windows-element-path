*** Settings ***
Library     ExtendedWindows


*** Tasks ***
Minimal task
    ${win}=    Control Window    name:Calculator
    # Print Tree    name:Calculator
    # First number is the first child element and so on
    Click Element Path    2 | 3 | 2 | 8 | 2    # number 1
    # Spaces are not necessary between indexes
    Click Element Path    2|3|2|8|3    # number 2
    Click Element Path    2|3|2|8|5    # number 4
    # Sleep for demo purposes
    Sleep    2s
    Click Element Path    1|4    # close button
    Log    Done.
