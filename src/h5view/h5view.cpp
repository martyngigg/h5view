#include "h5view.hpp"
#include "H5Cpp.h"

using namespace H5;


namespace h5view {

/**
 * @param filepath A full path to the file
 */
std::string first_object_name(const std::string &filepath) {
  H5File h5file(filepath, H5F_ACC_RDONLY);
  return h5file.getObjnameByIdx(0);
}

/**
 * @param filepath A full path to the file
 * @param groupname The name of the group to open
 */
 std::vector<double> object_value(const std::string &filepath,
                                  const std::string &groupname) {
  H5File h5file(filepath, H5F_ACC_RDONLY);
  auto dataset = h5file.openDataSet(filepath);
  std::vector<double> buffer(dataset.getStorageSize());
  dataset.read((void*)buffer.data(), PredType::NATIVE_DOUBLE);
  return buffer;
}

}
