#include <iostream>

#include "h5view/h5view.hpp"

using std::cerr;
using h5view::root_group_name;

int main(int argc, char **argv) {
  if(argc != 2) {
    cerr << "Usage: h5viewer filepath\n";
    return 1;
  }
  root_group_name(argv[1]);
  return 0;
}
