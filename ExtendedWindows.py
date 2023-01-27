from RPA.Windows import Windows
from RPA.core.windows.locators import WindowsElement
from robot.api.deco import keyword
import logging


class ExtendedWindows(Windows):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    @keyword
    def click_element_path(self, element_path: str, log_elements: bool = False):
        root = self.window_element.item
        element_index_path = [item.strip() for item in element_path.split("|")]
        child_elements = []
        target = None
        for idx in element_index_path:
            child_idx = int(idx) - 1
            if log_elements:
                logging.warning(root)
            child_elements = root.GetChildren()
            if child_idx < len(child_elements):
                root = child_elements[child_idx]
                root.robocorp_click_offset = None
                target = WindowsElement(root, element_path)
        self.click(target)
