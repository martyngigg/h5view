#include "h5view/h5view.hpp"

#include <H5Cpp.h>
#include <gtest/gtest.h>

using h5view::first_object_name;


TEST(h5viewtest, empty_string_throws) {
  ASSERT_THROW(first_object_name(""), H5::Exception);
}

TEST(h5viewtest, first_object_name_returns_first_name) {
  const auto element_name = first_object_name(std::string(std::getenv("H5VIEW_DATA_DIR")) + "/tiny.h5");
  ASSERT_EQ("data", element_name);
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
