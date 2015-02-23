#script compile kernel acer e2 by doha saizo
#setting build

toolchain="$HOME/kernel_build/android-toolchain-eabi-4.9/bin/arm-linux-androideabi-"
source_path="$HOME/kernel_build/acer_v370_kk"
#/home/doha/toolchain-4.6.3/bin/arm-linux-androideabi-

# CCACHE
export CCACHE_DIR="$HOME/.ccache"
export CC=ccache gcc
export PATH=/usr/lib/ccache:$PATH
export USE_CCACHE=1
export CROSS_COMPILE=$toolchain

./makeMtk -o=TARGET_BUILD_VARIANT=user n k

cd $source_path/mediatek/build/tools
./mkimage $source_path/out/target/product/doha86_wet_kk/obj/KERNEL_OBJ/arch/arm/boot/zImage KERNEL > $source_path/mtktools/boot.img-kernel.img

cd $source_path/mtktools
./repack.pl -boot boot.img-kernel.img boot.img-ramdisk $source_path/mtktools/doha/boot.img

cd $source_path/mtktools/doha
zip -r out .
mv $source_path/mtktools/doha/out.zip $source_path/kernel3.4.67KK.zip
