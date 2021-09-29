set -e
cd build/hypertrash_os
make clean 
cd -
python3 gen_spec.py bhyve_intel_hda
#python3 gen_spec.py bhyve_e1000
cd build 
cp bytecode_spec.template.h bytecode_spec.h
cd hypertrash_os
make

cd ../../

cp build/hypertrash_os/iso/hypertrash_os_bios.iso ../../Targets/bhyve/sharedir/hypertrash.iso
cp spec.msgp ../../Targets/bhyve/sharedir/spec.msgp

cd build/hypertrash_os
make clean 
cd -
python3 gen_spec.py legacy_xhci
cd build 
cp bytecode_spec.template.h bytecode_spec.h
cd hypertrash_os
make

cd ../../

cp build/hypertrash_os/iso/hypertrash_os_bios.iso ../../Targets/qemu/sharedir_asan/hypertrash.iso
cp spec.msgp ../../Targets/qemu/sharedir_asan/spec.msgp



