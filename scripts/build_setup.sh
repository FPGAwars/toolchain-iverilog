# Build setup script

if [ $ARCH == "linux_x86_64" ]; then
  HOST="x86_64-linux-gnu"
  CONFIG_LDFLAGS="-static-libstdc++"
  MAKE_LDFLAGS="-static"
fi

if [ $ARCH == "linux_i686" ]; then
  HOST="x86_64-linux-gnu"
  CONFIG_LDFLAGS="-static-libstdc++"
  CONFIG_FLAGS="--with-m32"
  MAKE_LDFLAGS="-m32 -static"
fi

if [ $ARCH == "linux_armv7l" ]; then
  HOST="arm-linux-gnueabihf"
  CONFIG_LDFLAGS="-static-libstdc++"
  MAKE_LDFLAGS="-static"
fi

if [ $ARCH == "linux_aarch64" ]; then
  HOST="aarch64-linux-gnu"
  CONFIG_LDFLAGS="-static-libstdc++"
  MAKE_LDFLAGS="-static"
fi

if [ $ARCH == "windows_x86" ]; then
  EXE=".exe"
fi

if [ $ARCH == "windows_amd64" ]; then
  EXE=".exe"
fi

if [ $ARCH == "darwin" ]; then
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi
