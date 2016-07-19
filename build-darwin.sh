VERSION=2
UPSTREAM=upstream
PACK_DIR=packages
ARCH=darwin
HOST=i686-apple-dar
BUILD_DIR=build_$ARCH
PACKNAME=toolchain-iverilog-$ARCH-$VERSION
TARBALL=$PACKNAME.tar.bz2

# Toolchain name
NAME=toolchain-iverilog

# IVERILOG
GIT_REPO=https://github.com/steveicarus/iverilog/archive
FILENAME=iverilog-10_1
FILENAME_TAR=v10_1.tar.gz

# Store current dir
WORK=$PWD

# -- TARGET: CLEAN. Remove the build dir and the generated packages
# --  then exit
if [ "$1" == "clean" ]; then
  echo "--> CLEAN"

  # -- Remove the build dir
  rm -rf $WORK/$BUILD_DIR

  # -- Remove the packages dir
  rm  -rf $WORK/$PACK_DIR

  exit
fi

# Install dependencies
# echo "Install dependencies:"

# Create the upstream folder
mkdir -p $UPSTREAM

# Create the packages directory
mkdir -p $PACK_DIR
mkdir -p $PACK_DIR/$BUILD_DIR
mkdir -p $PACK_DIR/$BUILD_DIR/$NAME

# Create the build dir
mkdir -p $BUILD_DIR

#-- Download the src tarball, if it has not been done yet
cd $UPSTREAM
test -e $FILENAME_TAR ||
    (echo ' ' && \
    echo '--> DOWNLOADING IVERILOG source package' && \
    wget $GIT_REPO/$FILENAME_TAR)

#-- Extract the src files, if it has not been done yet
test -e $FILENAME ||
    (echo ' ' && \
    echo '--> UNCOMPRESSING IVERILOG package' && \
    tar zxvf $FILENAME_TAR)

#-- Copy the upstream libusb into the build dir
cd $WORK
test -d $BUILD_DIR/$FILENAME ||
     (echo ' ' && \
     echo '--> COPYING IVERILOG upstream into build_dir' && \
     cp -r $UPSTREAM/$FILENAME $BUILD_DIR)

#-- Building the IVERILOG library
cd $BUILD_DIR/$FILENAME

#-- Generate the new configure
sh autoconf.sh

# Prepare for building
./configure

# Compile!
make -j$(($(sysctl -n hw.ncpu)-1))

# Copy the dev files into $BUILD_DIR/include $BUILD_DIR/lbs
make install prefix=$WORK/$PACK_DIR/$BUILD_DIR/$NAME

# Copy the vlib directory
cp -r $WORK/vlib $WORK/$PACK_DIR/$BUILD_DIR/$NAME

#-- Create the package
echo ' '
echo '--> CREATING IVERILOG apio package'
cd $WORK/$PACK_DIR/$BUILD_DIR
tar vjcf $TARBALL $NAME
mv $TARBALL ..
