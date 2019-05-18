#include "h5view/h5view.hpp"

using h5view::root_group_name;

int main(int /*argc*/, char **argv) {
  root_group_name(argv[1]);
}
