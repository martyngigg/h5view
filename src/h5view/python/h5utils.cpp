#include <pybind11/pybind11.h>

#include "h5view/h5view.hpp"

namespace py = pybind11;

PYBIND11_MODULE(h5utils, module) {
  module.doc() = "Extension module to wrap h5view utilities";

  module.def("root_group_name", &h5view::root_group_name);
}
