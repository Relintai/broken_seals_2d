
export SCONS_CACHE=~/.scons_cache
export SCONS_CACHE_LIMIT=5000

cd ./engine

scons -j6 p=iphone tools=no target=release arch=arm module_arkit_enabled=no game_center=no
scons -j6 p=iphone tools=no target=release arch=arm64 module_arkit_enabled=no game_center=no
lipo -create bin/libgodot.iphone.opt.arm.a bin/libgodot.iphone.opt.arm64.a -output bin/libgodot.iphone.release.fat.a
rm bin/ios_xcode/libgodot.iphone.release.fat.a
cp bin/libgodot.iphone.release.fat.a  bin/ios_xcode/libgodot.iphone.release.fat.a

rm bin/iphone.zip
cd bin/ios_xcode
zip -r -X ../iphone.zip .

cd ..
cd ..


cd ..
