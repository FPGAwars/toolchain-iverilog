# -- Compile Iverilog script

VER=10_2
IVERILOG=iverilog-$VER
TAR_IVERILOG=v$VER.tar.gz
REL_IVERILOG=https://github.com/steveicarus/iverilog/archive/$TAR_IVERILOG

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Check and download the release
test -e $TAR_IVERILOG || wget $REL_IVERILOG

# -- Unpack the release
tar zxf $TAR_IVERILOG

# -- Copy the upstream sources into the build directory
rsync -a $IVERILOG $BUILD_DIR --exclude .git

cd $BUILD_DIR/$IVERILOG

# -- Configure qemu
if [ ${ARCH:0:7} == "linux_a" ]; then
  export QEMU_LD_PREFIX=/usr/$HOST
fi

if [ $ARCH != "darwin" ]; then
  export CC=$HOST-gcc
  export CXX=$HOST-g++
fi

# -- Generate the new configure
sh autoconf.sh

# -- Prepare for building
./configure --build=$BUILD --host=$HOST CFLAGS="$CONFIG_CFLAGS" CXXFLAGS="$CONFIG_CFLAGS" LDFLAGS="$CONFIG_LDFLAGS" $CONFIG_FLAGS

# -- Compile it
make -j$J

# -- Make binaries static
if [ ${ARCH:0:5} == "linux" ]; then
  SUBDIRS="driver vvp"
  for SUBDIR in ${SUBDIRS[@]}
  do
    make -C $SUBDIR clean
    make -C $SUBDIR -j$J LDFLAGS="$MAKE_LDFLAGS"
  done
fi

# -- Test the generated executables
if [ $ARCH != "darwin" ]; then
  test_bin driver/iverilog$EXE
  test_bin vvp/vvp$EXE
fi

if [ $ARCH == "linux" ]; then
  test_bin iverilog-vpi
fi

if [ $ARCH == "windows" ]; then
  test_bin driver-vpi/iverilog-vpi$EXE
fi

# -- Install the programs into the package folder
make install prefix=$PACKAGE_DIR/$NAME/

# -- Copy vlib/system.v
cp -r $WORK_DIR/build-data/vlib $PACKAGE_DIR/$NAME
