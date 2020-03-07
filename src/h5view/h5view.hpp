#ifndef H5VIEW_HPP_
#define H5VIEW_HPP_

#include "h5view_export.h"
#include <string>
#include <vector>

namespace h5view {

/// Return the name of the first element
H5VIEW_EXPORT std::string first_object_name(const std::string &filename);

/// Return value of the first element
H5VIEW_EXPORT std::vector<double> object_value(const std::string &filename,
                                               const std::string &groupname);

}

#endif // H5VIEW_HPP_
