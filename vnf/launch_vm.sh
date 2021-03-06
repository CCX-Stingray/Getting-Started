/usr/libexec/qemu-kvm -smp 2 -m 2048 -bios QEMU_EFI.fd -nographic \
       -machine virt-rhel7.6.0,accel=kvm,usb=off,dump-guest-core=off,gic-version=3 \
       -device virtio-blk-device,drive=image \
       -drive if=none,id=image,file=bionic-server-cloudimg-arm64.img \
       -drive file=ubuntu-bionic-1-cidata.iso,id=cloud,if=none,media=cdrom \
         -device virtio-scsi-device -device scsi-cd,drive=cloud \
       -netdev user,id=user0,hostfwd=tcp::2222-:22,net=192.168.76.0/24,dhcpstart=192.168.76.9 \
         -device virtio-net-device,netdev=user0 \
       -device vfio-pci,host=0008:01:03.0 \
       -device vfio-pci,host=0008:01:05.0 \
       -cpu host
