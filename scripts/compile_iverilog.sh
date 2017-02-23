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

#-- Generate the new configure
sh autoconf.sh

# Prepare for building
./configure --host=$HOST LDFLAGS="$CONFIG_LDFLAGS" $CONFIG_FLAGS

# -- Compile it
make -j$J

if [ ${ARCH:0:5} == "linux" ]; then
  # Make binaries static
  SUBDIRS="driver vvp ivlpp"
  for SUBDIR in ${SUBDIRS[@]}
  do
    make -C $SUBDIR clean
    make -C $SUBDIR -j$J LDFLAGS="$MAKE_LDFLAGS"
  done
fi



if [ $ARCH == "linux_armv7l" ]; then
  #-- Generate the new configure
  autoconf

  # Prepare for building
  ./configure --host="arm-linux-gnueabihf" LDFLAGS="-static-libstdc++"

  # Apply cross-execution patch
  sed -i 's/.\/version.exe `/qemu-arm -L \/usr\/arm-linux-gnueabihf\/ version.exe `/g' Makefile Makefile.in
  sed -i 's/..\/version.exe `/qemu-arm -L \/usr\/arm-linux-gnueabihf\/ ..\/version.exe `/g' driver/Makefile driver/Makefile.in
  sed -i 's/..\/version.exe `/qemu-arm -L \/usr\/arm-linux-gnueabihf\/ ..\/version.exe `/g' vvp/Makefile vvp/Makefile.in
  sed -i 's/.\/draw_tt.exe/qemu-arm -L \/usr\/arm-linux-gnueabihf\/ draw_tt.exe/g' vvp/Makefile

  # -- Compile it
  make -j$J

  # Make iverilog static
  cd driver
  make clean
  make -j$J LDFLAGS="-static"
  cd ..
fi

if [ $ARCH == "linux_aarch64" ]; then
  #-- Generate the new configure
  autoconf

  # Prepare for building
  ./configure --host="aarch64-linux-gnu" LDFLAGS="-static-libstdc++"

  # Apply cross-execution patch
  sed -i 's/.\/version.exe `/qemu-aarch64 -L \/usr\/aarch64-linux-gnu\/ version.exe `/g' Makefile Makefile.in
  sed -i 's/..\/version.exe `/qemu-aarch64 -L \/usr\/aarch64-linux-gnu\/ ..\/version.exe `/g' driver/Makefile driver/Makefile.in
  sed -i 's/..\/version.exe `/qemu-aarch64 -L \/usr\/aarch64-linux-gnu\/ ..\/version.exe `/g' vvp/Makefile vvp/Makefile.in
  sed -i 's/.\/draw_tt.exe/qemu-aarch64 -L \/usr\/aarch64-linux-gnu\/ draw_tt.exe/g' vvp/Makefile

  # -- Compile it
  make -j$J

  # Make iverilog static
  cd driver
  make clean
  make -j$J LDFLAGS="-static"
  cd ..
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
fi

# -- Install the programs into the package folder
make install prefix=$PACKAGE_DIR/$NAME/

# -- Copy vlib/system.v
cp -r $WORK_DIR/build-data/vlib $PACKAGE_DIR/$NAME
