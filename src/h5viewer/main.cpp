#include <iostream>

#include "h5view/h5view.hpp"

using std::cerr;
using std::cout;
using h5view::first_object_name;

int main(int argc, char **argv) {
  if(argc != 2) {
    cerr << "Usage: h5viewer filepath\n";
    return 1;
  }
  std::cout << "First object name=" << first_object_name(argv[1]) << "\n";
  return 0;
}
