chmod +x req_data
du -hs req_data
sha1sum req_data

./req_data hypertrash.iso hypertrash.iso
./req_data hypertrash_crash_detector hypertrash_crash_detector
./req_data hypertrash_crash_detector_asan hypertrash_crash_detector_asan
./req_data set_kvm_ip_range set_kvm_ip_range
./req_data set_ip_range set_ip_range

chmod +x hypertrash_crash_detector
chmod +x hypertrash_crash_detector_asan
chmod +x set_kvm_ip_range
chmod +x set_ip_range

#./set_kvm_ip_range
#./set_ip_range 0x1000 0x7ffffffff000 1

# disable ASLR
echo 0 > /proc/sys/kernel/randomize_va_space

./set_ip_range 0x1000 0x7ffffffff000 0

echo 0 > /proc/sys/kernel/printk

clear

qemu-img create hdd.img 10M
LD_PRELOAD=./hypertrash_crash_detector sudo /home/user/qemu-5.2.0/build/qemu-system-x86_64 -cdrom hypertrash.iso -enable-kvm -m 100 -net none -device megasas,id=scsi -device scsi-hd,drive=SysDisk -drive id=SysDisk,if=none,file=hdd.img 

