*** Settings ***
Documentation       Using element path locator for application elements.

Library             RPA.Windows


*** Variables ***
${path_to_mainview}             path:2|3|2
${path_to_result}               ${path_to_mainview}|2|1    # path:2|3|2|2|1
# Different element sections
${path_to_controls}             ${path_to_mainview}|5    # path:2|3|2|5
${path_to_operators}            ${path_to_mainview}|7    # path:2|3|2|7
${path_to_numberpad}            ${path_to_mainview}|8    # path:2|3|2|8
# Clear button in Controls section
${path_to_clear_button}         ${path_to_controls}|3    # path:2|3|2|5|3
# Buttons in Operators section
${path_to_minus_button}         ${path_to_operators}|3    # path:2|3|2|7|3
${path_to_plus_button}          ${path_to_operators}|4    # path:2|3|2|7|4
${path_to_equals_button}        ${path_to_operators}|5    # path:2|3|2|7|5
${locator_to_number_five}       path:2|3|2 > id:num5Button


*** Tasks ***
Minimal task
    Control Window    name:Calculator
    Print Tree    log_as_warnings=True
    Click    ${path_to_clear_button}
    ${operations}=    Set Variable    ${EMPTY}
    FOR    ${_}    IN RANGE    6
        ${number}=    Evaluate    random.randint(1,9)
        IF    $number%2 == 0
            Click    ${path_to_plus_button}
            ${operations}=    Set Variable    ${operations}+
        ELSE
            Click    ${path_to_minus_button}
            ${operations}=    Set Variable    ${operations}-
        END
        ${operations}=    Set Variable    ${operations}${number}
        Click    ${path_to_numberpad} > path:${number+1}
        Sleep    0.5s
    END
    Click    ${path_to_equals_button}
    ${result}=    Get Element    ${path_to_result}
    ${operations}=    Set Variable    ${operations}=${result.name}
    Log To Console    \nCalculated: ${operations}
    # Lets add 5 more to the result
    Click    ${locator_to_number_five}
    Log    Done.
