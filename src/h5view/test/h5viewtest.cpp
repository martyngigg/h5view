#include "h5view/h5view.hpp"
#include <H5Cpp.h>
#include <gtest/gtest.h>
#include <stdexcept>

using h5view::root_group_name;

TEST(h5viewtest, empty_string_throws) {
  ASSERT_THROW(root_group_name(""), H5::Exception);
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
