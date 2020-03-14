#!/bin/bash
set -ex

if [ $# -ne 4 ]; then
    echo "Usage: sonarcloud-build-and-scan.sh token src-dir build-dir"
    exit 1
fi

# Build configuration
SRCDIR=$2
BUILDDIR=$3
PRID=$4

# Configuration for SonarCloud
SONAR_TOKEN=$1
export SONAR_SCANNER_VERSION=4.2.0.1873
export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
export SONAR_SCANNER_OPTS="-server"
export PATH=$HOME/.sonar/build-wrapper-linux-x86:$PATH
if [ ! -d $HOME/.sonar ]; then
    mkdir $HOME/.sonar

    # download sonar-scanner
    curl -sSLo $HOME/.sonar/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
    unzip -o $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/

    # download build-wrapper
    curl -sSLo $HOME/.sonar/build-wrapper-linux-x86.zip https://sonarcloud.io/static/cpp/build-wrapper-linux-x86.zip
    unzip -o $HOME/.sonar/build-wrapper-linux-x86.zip -d $HOME/.sonar/
fi

# Build and test with coverage
rm -fr ${BUILDDIR}
mkdir ${BUILDDIR}
cd ${BUILDDIR}
conan install --no-imports ../
cmake -G Ninja -DENABLE_TESTING=ON -DENABLE_COVERAGE=ON ${SRCDIR}
BUILD_WRAPPER_OUTPUT_DIR=sonarcloud-scanner
CCACHE_DISABLE=1 build-wrapper-linux-x86-64 --out-dir ${BUILD_WRAPPER_OUTPUT_DIR} cmake --build .
ctest -j8
${BUILDDIR}/pyvenv/bin/coverage xml

# Run sonar scanner
sonar-scanner \
  -Dsonar.projectBaseDir=${SRCDIR} \
  -Dsonar.login=${SONAR_TOKEN} \
  -Dsonar.cfamily.build-wrapper-output=${BUILD_WRAPPER_OUTPUT_DIR} \
  -Dsonar.cfamily.gcov.reportsPath=${BUILDDIR} \
  -Dsonar.python.coverage.reportPaths=${BUILDDIR} \
  -Dsonar.pullrequest.key=${PRID}
