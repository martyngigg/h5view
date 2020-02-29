#!/bin/bash
set -ex

if [ $# -ne 3 ]; then
    echo "Usage: sonarcloud-build-and-scan.sh token src-dir build-dir"
    exit 1
fi

# Build configuration
SRCDIR=$2
BUILDDIR=$3

# Configuration for SonarCloud
SONAR_TOKEN=$1
SONAR_PROJECT_KEY=martyngigg_h5view
SONAR_PROJECT_NAME=martyngigg_h5view
SONAR_ORGANIZATION=martyngigg

# Set default to SONAR_HOST_URL in not provided
SONAR_HOST_URL=${SONAR_HOST_URL:-https://sonarcloud.io}
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

# rm -fr $BUILDDIR
# mkdir $BUILDDIR
cd $BUILDDIR
ninja clean
# conan install --no-imports ../
# cmake -G Ninja $SRCDIR
# # Build inside the build-wrapper
 BUILD_WRAPPER_OUTPUT_DIR=sonarcloud-scanner
CCACHE_DISABLE=1 build-wrapper-linux-x86-64 --out-dir $BUILD_WRAPPER_OUTPUT_DIR  cmake --build .

# Run sonar scanner (here, arguments are passed through the command line but most of them can be written in the sonar-project.properties file)
[[ -v SONAR_TOKEN ]] && SONAR_TOKEN_CMD_ARG="-Dsonar.login=${SONAR_TOKEN}"
[[ -v SONAR_ORGANIZATION ]] && SONAR_ORGANIZATION_CMD_ARG="-Dsonar.organization=${SONAR_ORGANIZATION}"
[[ -v SONAR_PROJECT_NAME ]] && SONAR_PROJECT_NAME_CMD_ARG="-Dsonar.projectName=${SONAR_PROJECT_NAME}"
SONAR_OTHER_ARGS="-Dsonar.projectVersion=1.0 -Dsonar.projectBaseDir=${SRCDIR} -Dsonar.sources=${SRCDIR}/src -Dsonar.cfamily.build-wrapper-output=${BUILD_WRAPPER_OUTPUT_DIR} -Dsonar.cfamily.gcov.reportsPath=. -Dsonar.sourceEncoding=UTF-8"
sonar-scanner -Dsonar.host.url="${SONAR_HOST_URL}" -Dsonar.projectKey=${SONAR_PROJECT_KEY} ${SONAR_OTHER_ARGS} ${SONAR_PROJECT_NAME_CMD_ARG} ${SONAR_TOKEN_CMD_ARG} ${SONAR_ORGANIZATION_CMD_ARG}
