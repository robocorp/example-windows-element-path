*** Settings ***
Documentation       Using the element path strategy when locating application elements.

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
Automate Calculator
    [Setup]    Windows Run    calc.exe

    # Display the element tree of the Calculator window.
    Control Window    Calculator
    ${structure} =    Print Tree    log_as_warnings=${True}    return_structure=${True}
    Log To Console    Structure: ${structure}

    # Clear display and add/subtract random numbers.
    Click    ${path_to_clear_button}
    ${operations} =    Set Variable    ${EMPTY}
    FOR    ${_}    IN RANGE    6
        ${number} =    Evaluate    random.randint(1,9)
        IF    ${number} % 2 == 0
            Click    ${path_to_plus_button}
            ${operations} =    Set Variable    ${operations}+
        ELSE
            Click    ${path_to_minus_button}
            ${operations} =    Set Variable    ${operations}-
        END
        ${operations} =    Set Variable    ${operations}${number}
        Click    ${path_to_numberpad} > path:${number + 1}    wait_time=0.5
    END

    # Generate result and extract the total from display.
    Click    ${path_to_equals_button}
    ${result} =    Get Element    ${path_to_result}
    ${operations} =    Set Variable    ${operations}=${result.name}
    Log    Calculated expression: ${operations}

    # Lets add number "5" to the total by pressing this key. (on Windows 11 it replaces
    #  the result)
    Click    ${locator_to_number_five}

    [Teardown]    Close Current Window
