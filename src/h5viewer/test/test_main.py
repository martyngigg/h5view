# std imports
import unittest

# main
from main import main


class MainTest(unittest.TestCase):

    def test_main(self):
        result = main()
        self.assertTrue(result is None)


if __name__ == '__main__':
    unittest.main()
