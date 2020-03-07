#include "h5view.hpp"
#include "H5Cpp.h"
#include <iostream>

using namespace H5;
using std::cout;

namespace {
  herr_t display_element_name(hid_t /*group*/,
                              const char *name,
                              void */*op_data*/) {
    std::cout << name << "\n";
    return 0;
  }
}

namespace h5view {

/**
 * Print the name of the root group in the file
 * @param filepath A full path to the file
 */
void root_group_name(const std::string &filepath) {
  std::cout << "Opening '" << filepath << "'\n";
  H5File h5file(filepath, H5F_ACC_RDONLY);
  std::cout << "\nroot attributes:\n";
  int unusedArg{0};
  h5file.iterateElems("/", &unusedArg, display_element_name, nullptr);
}

}
