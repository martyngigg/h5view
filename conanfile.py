from conans import ConanFile


class H5ViewConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    requires = [
        "hdf5/1.10.5-dm2@ess-dmsc/stable", "Python/3.8.0"
    ]
    build_requires = "pybind11/2.3.0@conan/stable"
    generators = "cmake"
    default_options = {
        "*:shared": True,
        "hdf5:cxx": True
    }

    def imports(self):
        self.copy("python*", dst="bin", src="bin")
        self.copy("*.so*", dst="lib", src="lib")
        self.copy("python3.8/*", dst="lib", src="lib")
