### Using the element path strategy when locating application elements.

import io
import random

from robocorp.tasks import task, setup, ITask
from robocorp import log
from robocorp import windows

APP_EXECUTABLE = "calc.exe"
APP_LOCATOR = "name:Calculator"
PATH_TO_MAINVIEW = "path:2|3|2"
PATH_TO_RESULT = f"{PATH_TO_MAINVIEW}|2|1" # path:2|3|2|2|1
# Different element sections
PATH_TO_CONTROLS = f"{PATH_TO_MAINVIEW}|5" # path:2|3|2|5
PATH_TO_OPERATORS = f"{PATH_TO_MAINVIEW}|7" # path:2|3|2|7
PATH_TO_NUMBERPAD = f"{PATH_TO_MAINVIEW}|8" # path:2|3|2|8
# Clear button in Controls section
PATH_TO_CLEAR_BUTTON = f"{PATH_TO_CONTROLS}|3" # path:2|3|2|5|3
# Buttons in Operators section
PATH_TO_MINUS_BUTTON = f"{PATH_TO_OPERATORS}|3" # path:2|3|2|7|3
PATH_TO_PLUS_BUTTON = f"{PATH_TO_OPERATORS}|4" # path:2|3|2|7|4
PATH_TO_EQUALS_BUTTON = f"{PATH_TO_OPERATORS}|5" # path:2|3|2|7|5
PATH_TO_TO_NUMBER_FIVE = "path:2|3|2 > id:num5Button"

AMOUNT_OF_NUMBERS = 6

def log_element_tree(window_element: windows.WindowElement) -> None:
    with io.StringIO() as string_buffer:
        window_element.print_tree(stream=string_buffer, show_properties=True, max_depth=10)
        log.debug(string_buffer.getvalue())

def clear_screen(windows_element: windows.WindowElement) -> None:
    windows_element.click(PATH_TO_CLEAR_BUTTON)

def calculate_random_numbers(windows_element: windows.WindowElement) -> None:
    numbers = random.sample(range(1, 9), AMOUNT_OF_NUMBERS)
    for number in numbers:
        if number % 2 == 0:
            windows_element.click(PATH_TO_PLUS_BUTTON)
        else:
            windows_element.click(PATH_TO_MINUS_BUTTON)
        windows_element.click(f"{PATH_TO_NUMBERPAD} > path:{number + 1}")

def generate_result(windows_element: windows.WindowElement) -> None:
    windows_element.click(PATH_TO_EQUALS_BUTTON)
    result = windows_element.find(PATH_TO_RESULT)
    log.console_message(f"Calculated expression: {result.name}\n", kind="regular")

def click_number_five(windows_element: windows.WindowElement) -> None:
    # Lets add number "5" to the total by pressing this key. (on Windows 11, this
    # replaces the result with the pressed value)
    windows_element.click(PATH_TO_TO_NUMBER_FIVE)

@setup
def start_calculator(task: ITask) -> windows.WindowElement:
    """
    Do the setup actions before starting the task.
    """
    windows.desktop().windows_run(text=APP_EXECUTABLE)

@task
def automate_calculator() -> None:
    """
    Automate simple calculator actions.
    """
    windows_element = windows.find_window(APP_LOCATOR)
    try:
        log_element_tree(windows_element)
        clear_screen(windows_element)
        calculate_random_numbers(windows_element)
        generate_result(windows_element)
        click_number_five(windows_element)
    finally:
        windows_element.close_window()
