echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'
echo '1' > '/sys/module/snd_hda_intel/parameters/power_save'
echo 'min_power' > '/sys/class/scsi_host/host4/link_power_management_policy'
echo 'min_power' > '/sys/class/scsi_host/host5/link_power_management_policy'
echo 'min_power' > '/sys/class/scsi_host/host2/link_power_management_policy'
echo 'min_power' > '/sys/class/scsi_host/host3/link_power_management_policy'
echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy'
echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy'
echo 'auto' > '/sys/bus/pci/devices/0000:0f:00.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:0d:00.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:0d:00.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:05.3/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:05.2/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:05.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:05.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:03.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:08.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:08.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:08.2/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:08.3/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:10.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:10.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:16.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:19.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1a.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1b.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:04.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:01:00.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.4/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:04.3/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.3/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.2/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1e.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1d.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.6/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.7/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:03:00.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:17:00.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:00.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:00.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:02.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:02.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:03.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:03.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:03.4/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:04.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:ff:04.2/power/control'
ethtool -s enp0s25 wol d
