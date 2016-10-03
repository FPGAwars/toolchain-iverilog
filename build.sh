#!/bin/bash
##################################
#   Iverilog toolchain builder   #
##################################

# Generate toolchain-iverilog-arch-ver.tar.gz from source code
# sources: http://iverilog.icarus.com/

VERSION=1.0.0

# -- Target architectures
ARCHS=( )
# ARCHS=( linux_x86_64 linux_i686 linux_armv7l linux_aarch64 windows )
# ARCHS=( darwin )

# -- Toolchain name
NAME=toolchain-iverilog

# -- Debug flags
INSTALL_DEPS=1
COMPILE_IVERILOG=1
CREATE_PACKAGE=1

# -- Store current dir
WORK_DIR=$PWD
# -- Folder for building the source code
BUILDS_DIR=$WORK_DIR/_builds
# -- Folder for storing the generated packages
PACKAGES_DIR=$WORK_DIR/_packages
# --  Folder for storing the source code from github
UPSTREAM_DIR=$WORK_DIR/_upstream

# -- Create the build directory
mkdir -p $BUILDS_DIR
# -- Create the packages directory
mkdir -p $PACKAGES_DIR
# -- Create the upstream directory and enter into it
mkdir -p $UPSTREAM_DIR

# -- Test script function
function test_bin {
  $WORK_DIR/test/test_bin.sh $1
  if [ $? != "0" ]; then
    exit 1
  fi
}
# -- Print function
function print {
  echo ""
  echo $1
  echo ""
}

# -- Check ARCHS
if [ ${#ARCHS[@]} -eq 0 ]; then
  print "NOTE: add your architectures to the ARCHS variable in the build.sh script"
fi

# -- Loop
for ARCH in ${ARCHS[@]}
do

  echo ""
  echo ">>> ARCHITECTURE $ARCH"

  # -- Directory for compiling the tools
  BUILD_DIR=$BUILDS_DIR/build_$ARCH

  # -- Directory for installation the target files
  PACKAGE_DIR=$PACKAGES_DIR/build_$ARCH

  # -- Remove the build dir and the generated packages then exit
  if [ "$1" == "clean" ]; then

    # -- Remove the package dir
    rm -r -f $PACKAGE_DIR

    # -- Remove the build dir
    rm -r -f $BUILD_DIR

    print ">> CLEAN"
    continue
  fi

  # --------- Instal dependencies ------------------------------------
  if [ $INSTALL_DEPS == "1" ]; then

    print ">> Install dependencies"
    . $WORK_DIR/scripts/install_dependencies.sh

  fi

  # --------- Compile iverilog ---------------------------------------
  if [ $COMPILE_IVERILOG == "1" ]; then

    # -- Create the build dir
    mkdir -p $BUILD_DIR

    print ">> Compile iverilog"
    . $WORK_DIR/scripts/compile_iverilog.sh

  fi

  # --------- Create the package -------------------------------------
  if [ $CREATE_PACKAGE == "1" ]; then

    print ">> Create package"
    . $WORK_DIR/scripts/create_package.sh

  fi

done
