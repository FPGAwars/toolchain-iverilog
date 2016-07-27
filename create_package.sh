# -- Create package script

cd $PACKAGE_DIR

if [ $ARCH == "windows" ]; then
  zip -r $NAME-$ARCH-$VERSION.zip $NAME
else
  tar vjcf $NAME-$ARCH-$VERSION.tar.bz2 $NAME
fi
