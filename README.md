H5View
------

A sample project to test out using the Conan package manager
and produces a library & application that is packaged with
all of its dependencies.

Prerequisites
-------------

The project requires [conan](https://docs.conan.io) to be installed with the following remotes
set up:

```console
conan remote add ess-dmsc https://api.bintray.com/conan/ess-dmsc/conan
```

Configuration
-------------

If the source is cloned to a directory `<src>` then

```console
cd <src>
mkdir build
cd build
conan install --no-imports ..
cmake -DENABLE_CPACK=ON -DCMAKE_INSTALL_PREFIX=/opt/hdf5view ..
cmake --build . --target package .
```

To run the program point the `bin/h5viewer` at a HDF5 file.
A `.rpm` or `.deb` package will be created in root of the build directory.
