#ifndef H5VIEW_HPP_
#define H5VIEW_HPP_

#include "h5view_export.h"
#include <string>

namespace h5view {

/// Display name of the root group
H5VIEW_EXPORT void root_group_name(const std::string &filename);

}

#endif // H5VIEW_HPP_
