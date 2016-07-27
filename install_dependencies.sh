# Install dependencies script

if [ $ARCH == "linux_x86_64" ]; then
  sudo apt-get install -y build-essential bison flex gperf libtool autoconf
fi

if [ $ARCH == "linux_i686" ]; then
  sudo apt-get install -y build-essential bison flex gperf libtool autoconf \
                          gcc-multilib g++-multilib

fi

if [ $ARCH == "linux_armv7l" ]; then

fi

if [ $ARCH == "linux_aarch64" ]; then

fi

if [ $ARCH == "darwin" ]; then

fi

if [ $ARCH == "windows" ]; then
  sudo apt-get install -y build-essential bison flex gperf libtool autoconf \
                          mingw-w64 mingw-w64-tools zip
fi
