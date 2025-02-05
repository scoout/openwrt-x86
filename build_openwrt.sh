#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="22.03.5"
BOARD_NAME="x86"
BOARD_SUBNAME="64"
BUILDER="https://downloads.openwrt.org/releases/${BUILD_VERSION}/targets/${BOARD_NAME}/${BOARD_SUBNAME}/openwrt-imagebuilder-${BUILD_VERSION}-${BOARD_NAME}-${BOARD_SUBNAME}.Linux-x86_64.tar.xz"
KERNEL_PARTSIZE=200 #Kernel-Partitionsize in MB
ROOTFS_PARTSIZE=5120 #Rootfs-Partitionsize in MB

BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

# Packages are added if no prefix is given, '-packaganame' does not integrate a package
sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$KERNEL_PARTSIZE/g" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE/g" .config

make image PROFILE="generic" \
        PACKAGES="kmod-rt2800-usb rt2800-usb-firmware kmod-rtl8192cu kmod-cfg80211 kmod-lib80211 kmod-mac80211 \
           wpa-supplicant hostapd base-files block-mount fdisk luci-app-minidlna minidlna samba4-server samba4-libs \
           luci-app-samba4 mmc-utils wireguard-tools luci-app-wireguard wpa-cli openvpn-openssl luci-app-openvpn watchcat \
           openssh-sftp-client firewall4 luci-base luci-ssl luci-mod-admin-full luci-theme-bootstrap kmod-usb-storage kmod-usb-ohci \
           kmod-usb-uhci e2fsprogs resize2fs htop debootstrap luci-compat luci-lib-ipkg -dnsmasq dnsmasq-full luci-app-ttyd irqbalance \
           ethtool comgt chat netperf speedtest-netperf iperf3 curl wget rsync file lsof less mc tree usbutils diffutils \
           openssh-sftp-server nano kmod-fs-exfat kmod-fs-ext4 urngd usign vpn-policy-routing wg-installer-client \
           kmod-usb-core kmod-usb-net kmod-mii kmod-usb3 dropbear zlib wireless-regdb f2fsck kmod-usb-wdm kmod-usb-net-ipheth usbmuxd usb-modeswitch \
           kmod-usb-net-asix-ax88179 kmod-usb-net-cdc-ether mount-utils kmod-rtl8xxxu kmod-rtl8187 rtl8188eu-firmware \
           kmod-rtl8192ce kmod-rtl8192de adblock luci-app-adblock kmod-fs-squashfs squashfs-tools-unsquashfs \
           squashfs-tools-mksquashfs luci-app-uhttpd kmod-fs-f2fs kmod-fs-vfat git git-http jq bash \
           kmod-usb-net-huawei-cdc-ncm kmod-usb-acm kmod-usb-net-cdc-ncm kmod-usb-net-qmi-wwan kmod-usb-net-rndis kmod-usb-serial-qualcomm kmod-usb-net-sierrawireless kmod-usb-ohci kmod-usb-serial ca-certificates curl coreutils coreutils-nohup ipset ip-full iptables-mod-tproxy iptables-mod-extra libcap libcap-bin ruby ruby-yaml unzip kmod-tun ip6tables-mod-nat kmod-inet-diag kmod-ipt-nat kmod-nft-tproxy kmod-nls-utf8 kmod-usb-serial-option kmod-usb-serial-sierrawireless kmod-usb-uhci kmod-usb2 kmod-usb3 kmod-usb-net-ipheth kmod-usb-net-cdc-mbim" \
        FILES="${BASEDIR}/files/" \
        BIN_DIR="${OUTPUT}"
