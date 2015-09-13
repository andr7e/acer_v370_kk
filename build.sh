#script compile kernel by andr7e
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

mtktools_path="$source_path/mtktools"
dest_cwm_path="$mtktools_path/cwm_recovery"
dest_twrp_path="$mtktools_path/twrp_recovery"

build_kernel()
{ 
   projectName="$1";

   echo "$projectName";
  
   ./makeMtk -o=TARGET_BUILD_VARIANT=user -t "$projectName" r k

   projectKernelName="boot.img-kernel-$projectName.img"
   projectDataName="$mtktools_path/$projectName"

   cd "$source_path/mediatek/build/tools"
   ./mkimage $source_path/out/target/product/"$projectName"/obj/KERNEL_OBJ/arch/arm/boot/zImage KERNEL > "$mtktools_path/$projectKernelName"

   cd "$mtktools_path"
   ./repack.pl -boot "$projectKernelName" boot.img-ramdisk "$projectDataName/boot.img"
   ./repack.pl -boot "$projectKernelName" boot.img-ramdisk-cm12 "$projectDataName-cm12/boot.img"
   #./repack.pl -boot "$projectKernelName" boot.img-ramdisk-cm12 "$projectDataName-cm12/boot-cm11.img"

   cd "$projectDataName"
   zip -r out .
   mv "$projectDataName/out.zip" "$source_path/build/$projectName-kernel3.4.67KK.zip"
}

repack_recovery()
{
   projectName="$1";
   type="$2";

   echo "$projectName";

   projectKernelName="boot.img-kernel-$projectName.img"
   projectDataName="$mtktools_path/$projectName"

   echo  "repacking $type..."
   dest_path="$source_path/build/recovery"
   cd $mtktools_path
   ./repack.pl -recovery "$projectKernelName" "recovery.img-ramdisk-$type" "$dest_path/recovery.img"
   cd $dest_path
   zip -r recovery .
   mv "$dest_path/recovery.zip" "$source_path/build/$projectName-$type-recovery.zip"
   rm "$dest_path/recovery.img"
}

recovery_param="recovery"

if [ "$1" = "list" ];
then
   echo "Available projects:"
   echo "acer89_v370_wet_kk"
   echo "fly89_iq446_wet_kk"
   echo "philips89_w6500_wet_kk"
   echo "hs89_alpha_rage_wet_kk"
else
   if [ "$2" = "$recovery_param" ];
   then
       repack_recovery "$1" "twrp"
   else
       build_kernel "$1"
   fi
fi
