#!/bin/bash
#set -x

EXCEPTIONS=
ESSENTIAL="AppleALC.kext"

# include subroutines
source "$(dirname ${BASH_SOURCE[0]})"/_tools/_install_subs.sh

warn_about_superuser

# install tools
install_tools

# remove old kexts
remove_deprecated_kexts
# EHCI is disabled, so no need for FakePCIID_XHCIMux.kext
remove_kext FakePCIID_XHCIMux.kext
# using AppleALC.kext, remove CodecCommander.kext and patched zml.zlib files
remove_kext CodecCommander.kext
sudo rm -f /System/Library/Extensions/AppleHDA.kext/Contents/Resources/*.zml.zlib
# also no need for FakePCIID.kext + FakePCIID_Intel_HDMI_Audio.kext
remove_kext FakePCIID.kext
remove_kext FakePCIID_Intel_HDMI_Audio.kext

# install required kexts
install_download_kexts
install_brcmpatchram_kexts

# LiluFriend and kernel cache rebuild
finish_kexts

# update kexts on EFI/CLOVER/kexts/Other
update_efi_kexts
EFI="$(./mount_efi.sh)"
rm -Rf "$EFI"/EFI/CLOVER/kexts/Other/FakePCIID.kext
rm -Rf "$EFI"/EFI/CLOVER/kexts/Other/FakePCIID_Intel_HDMI_Audio.kext

#EOF
