# -- Compile Iverilog script

VER=10_1
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

if [ ${ARCH:0:7} == "linux_a" ]; then
  # Configure qemu
  export QEMU_LD_PREFIX=/usr/$HOST
fi

#-- Generate the new configure
sh autoconf.sh

# Prepare for building
./configure --host=$HOST LDFLAGS="$CONFIG_LDFLAGS" $CONFIG_FLAGS

# -- Compile it
make -j$J

# Make binaries static
if [ ${ARCH:0:5} == "linux" ]; then
  SUBDIRS="driver ivlpp vvp"
  for SUBDIR in ${SUBDIRS[@]}
  do
    make -C $SUBDIR clean
    make -C $SUBDIR -j$J LDFLAGS="$MAKE_LDFLAGS"
  done
fi



if [ $ARCH == "windows" ]; then
  #-- Generate the new configure
  autoconf

  # Prepare for building
  ./configure --host="i686-w64-mingw32" LDFLAGS="-static"

  # -- Compile it
  make -j$J
fi

if [ $ARCH == "darwin" ]; then
  #-- Generate the new configure
  sh autoconf.sh

  # Prepare for building
  ./configure

  # -- Compile it
  make -j$J
fi

# -- Test the generated executables
if [ $ARCH != "darwin" ]; then
  test_bin driver/iverilog$EXE
  test_bin ivlpp/ivlpp$EXE
  test_bin vvp/vvp$EXE
fi

# -- Install the programs into the package folder
make install prefix=$PACKAGE_DIR/$NAME/

# -- Copy vlib/system.v
cp -r $WORK_DIR/build-data/vlib $PACKAGE_DIR/$NAME
