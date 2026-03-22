sudo mkdir -p /mnt/temp-root
sudo mount --bind / /mnt/temp-root
sudo rm -rf /mnt/temp-root/home/*
sudo umount /mnt/temp-root
