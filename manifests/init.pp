################################################################################
##  Mint 14 Puppet Manifest  ###################################################
################################################################################
# Copyright (C) 2013 Jason Unovitch, jason.unovitch@gmail.com                  #
#   https://github.com/junovitch                                               #
################################################################################
# Redistribution and use in source and binary forms, with or without           #
# modification, are permitted provided that the following conditions are met:  #
#                                                                              #
#    (1) Redistributions of source code must retain the above copyright        #
#    notice, this list of conditions and the following disclaimer.             #
#                                                                              #
#    (2) Redistributions in binary form must reproduce the above copyright     #
#    notice, this list of conditions and the following disclaimer in the       #
#    documentation and/or other materials provided with the distribution.      #
#                                                                              #
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED #
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF         #
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO   #
# EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,       #
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, #
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;  #
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,     #
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR      #
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF       #
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                                   #
################################################################################
#
# Purpose: Provides a one-stop shop manifest to cover a standard desktop
# configuration on my Linux Mint machines. This was my first experience
# learning Puppet for configuration management and it can be broken down to
# be smaller... But it works for me so I'll leave it as is. Feel free to use
# it however you see fit.
#
# Location:
# etc/puppet/modules/mint14/manifests/init.pp
#
# Prerequisites:
# Get the 'googlechrome' module - `puppet module install smarchive/googlechrome`
# Get the 'apt' module - `puppet module install puppetlabs/apt`
#
# Also, if you are looking to use this you'll need multiple installer packages
# that cannot be redistributed or you should be getting on your own from the
# trusted source. You'll have to review and update accordingly.
#
# Usage:
# Specify using the module in the site.pp manifest.
#   node mycomputer {
#     include mint14
#   }
#
# Warnings:
# Currently doesn't check for the PPA to be added before installing a package.
# This will cause an error when it first tries to install a package before
# adding the PPA. It will pick up the PPA and install during the next catalog
# run.
#
################################################################################


class mint14 {

  ##############################################################################
  # Set defaults for all Files
  ##############################################################################

  File {
    owner      => root,
    group      => root,
  }

  ##############################################################################
  # Security sensitive and snapshot repositories.  These are always the latest
  # for security reasons or because they change so fast.
  ##############################################################################

  package { 'adobe-flashplugin':
    ensure     => latest,
  }
  package { 'firefox':
    ensure     => latest,
  }
  class { 'googlechrome':
  }
  apt::ppa { 'ppa:stebbins/handbrake-snapshots': }
  package { 'handbrake-gtk':
    ensure     => latest,
  }
  package { 'icedtea-plugin':
    ensure     => latest,
  }
  package { 'icedtea-7-plugin':
    ensure     => latest,
  }
  package { 'openjdk-7-jre':
    ensure     => latest,
  }
  package { 'openjdk-6-jre':
    ensure     => latest,
  }
  package { 'skype':
    ensure     => latest,
  }
  package { 'thunderbird':
    ensure     => latest,
  }

  ##############################################################################
  # General Security tools
  ##############################################################################

  package { 'apparmor-profiles':
    ensure     => installed,
  }
  package { 'bleachbit':
    ensure     => installed,
  }
  package { 'chkrootkit':
    ensure     => installed,
  }
  package { 'clamav':
    ensure     => installed,
  }
  package { 'clamtk':
    ensure     => installed,
  }
  package { 'ecryptfs-utils':
    ensure     => installed,
  }
  package { 'fail2ban':
    ensure     => installed,
  }
  package { 'gufw':
    ensure     => installed,
  }
  package { 'kismet':
    ensure     => installed,
  }
  package { 'nmap':
    ensure     => installed,
  }
  package { 'openvpn':
    ensure     => installed,
  }
  package { 'putty':
    ensure     => installed,
  }
  package { 'sockstat':
    ensure     => installed,
  }
  package { 'tshark':
    ensure     => installed,
  }
  package { 'wireshark':
    ensure     => installed,
  }
  package { 'wireshark-doc':
    ensure     => installed,
  }

  ##############################################################################
  # Encfs Home directory support
  # http://wiki.debian.org/TransparentEncryptionForHomeFolder
  ##############################################################################

  package { 'fuse':
    ensure     => installed,
  }
  package { 'encfs':
    ensure     => installed,
  }
  package { 'libpam-encfs':
    ensure     => installed,
  }
  package { 'libpam-mount':
    ensure     => installed,
  }
  file { '/etc/fuse.conf':
    source     => 'puppet:///modules/mint14/common/etc/fuse.conf',
    group      => fuse,
    mode       => '0640',
    require    => Package['fuse'],
  }
  file { '/etc/security/pam_env.conf':
    source     => 'puppet:///modules/mint14/common/etc/security/pam_env.conf',
    mode       => '0644',
    require    => [ Package['libpam-encfs'], Package['encfs'] ],
  }
  file { '/etc/security/pam_encfs.conf':
    source     => 'puppet:///modules/mint14/common/etc/security/pam_encfs.conf',
    mode       => '0644',
    require    => [ Package['libpam-encfs'], Package['encfs'] ],
  }
  file { '/etc/pam.d/common-session':
    source     => 'puppet:///modules/mint14/common/etc/pam.d/common-session',
    mode       => '0644',
    require    => [ Package['libpam-encfs'], Package['encfs'] ],
  }

  ##############################################################################
  # Games
  ##############################################################################

  package { 'playonlinux':
    ensure     => installed,
  }
  package { 'openttd':
    ensure     => installed,
  }
  package { 'openttd-opensfx':
    ensure     => installed,
  }

  ##############################################################################
  # Steam + Dependencies
  ##############################################################################

  package { 'curl':
    ensure     => installed,
  }
  package { 'jockey-common':
    ensure     => installed,
  }
  package { 'nvidia-common':
    ensure     => installed,
  }
  package { 'python-xkit':
    ensure     => installed,
  }
  package { 'steam-launcher':
    ensure    => installed,
    provider  => dpkg,
    source    => '/usr/local/puppet-pkgs/steam.deb',
    require   => [ Package['curl'], Package['jockey-common'], Package['nvidia-common'], Package['python-xkit'], File['/usr/local/puppet-pkgs'] ],
  }

  ##############################################################################
  # Photography Applications
  ##############################################################################

  package { 'gimp':
    ensure     => installed,
  }
  package { 'gimp-data':
    ensure     => installed,
  }
  package { 'gimp-data-extras':
    ensure     => installed,
  }
  package { 'gimp-help-en':
    ensure     => installed,
  }
  package { 'hugin':
    ensure     => installed,
  }
  package { 'mypaint':
    ensure     => installed,
  }
  package { 'pandora':
    ensure     => installed,
  }
  package { 'pinta':
    ensure     => installed,
  }
  package { 'shotwell':
    ensure     => installed,
  }

  ##############################################################################
  # CLI Apps
  ##############################################################################

  package { 'clusterssh':
    ensure     => installed,
  }
  package { 'htop':
    ensure     => installed,
  }
  package { 'tcsh':
    ensure     => installed,
  }
  package { 'terminator':
    ensure     => installed,
  }
  package { 'tmux':
    ensure     => installed,
  }
  package { 'zsh':
    ensure     => installed,
  }
  package { 'zsh-doc':
    ensure     => installed,
  }

  ##############################################################################
  # System Apps
  ##############################################################################

  package { 'blueman':
    ensure     => installed,
  }
  package { 'gconf-editor':
    ensure     => installed,
  }
  package { 'gddrescue':
    ensure     => installed,
  }
  package { 'gparted':
    ensure     => installed,
  }
  apt::ppa { 'ppa:danielrichter2007/grub-customizer': }
  package { 'grub-customizer':
    ensure     => installed,
  }
  package { 'preload':
    ensure     => installed,
  }
  package { 'remmina':
    ensure     => installed,
  }
  package { 'synaptic':
    ensure     => installed,
  }
  package { 'etherwake':
    ensure     => installed,
  }
  package { 'wakeonlan':
    ensure     => installed,
  }

  ##############################################################################
  # Development Tools and Applications
  ##############################################################################

  package { 'build-essential':
    ensure     => installed,
  }
  package { 'check':
    ensure     => installed,
  }
  package { 'checkinstall':
    ensure     => installed,
  }
  package { 'cdbs':
    ensure     => installed,
  }
  package { 'devscripts':
    ensure     => installed,
  }
  package { 'dh-make':
    ensure     => installed,
  }
  package { 'eclipse':
    ensure     => installed,
  }
  package { 'fakeroot':
    ensure     => installed,
  }
  package { 'geany':
    ensure     => installed,
  }
  package { 'geany-plugins':
    ensure     => installed,
  }
  package { 'git':
    ensure     => installed,
  }
  package { 'git-core':
    ensure     => installed,
  }
  package { 'perl-tk':
    ensure     => installed,
  }
  package { 'qtcreator':
    ensure     => installed,
  }
  package { 'quickly':
    ensure     => installed,
  }
  package { 'subversion':
    ensure     => installed,
  }
  package { 'sharutils':
    ensure     => installed,
  }
  package { 'uudeview':
    ensure     => installed,
  }
  package { 'vim':
    ensure     => installed,
  }
  package { 'vim-gnome':
    ensure     => installed,
  }
  package { 'vim-doc':
    ensure     => installed,
  }
  package { 'vim-scripts':
    ensure     => installed,
  }
  package { 'vim-latexsuite':
    ensure     => installed,
  }

  ##############################################################################
  # HPLIP Printer Tools
  ##############################################################################

  package { 'hplip-gui':
    ensure     => installed,
  }

  ##############################################################################
  # Smartcard Support
  ##############################################################################

  package { 'libpcsclite1':
    ensure     => installed,
  }
  package { 'pcscd':
    ensure     => installed,
  }
  package { 'pcsc-tools':
    ensure     => installed,
  }

  ##############################################################################
  # Media Players
  ##############################################################################

  package { 'banshee':
    ensure     => installed,
  }
  package { 'banshee-extension-ampache':
    ensure     => installed,
  }
  package { 'vlc':
    ensure     => installed,
  }
  apt::ppa { 'ppa:ehoover/compholio': }
  package { 'netflix-desktop':
    ensure     => installed,
  }

  ##############################################################################
  # Audio Tools
  ##############################################################################

  package { 'audacity':
    ensure     => installed,
  }
  package { 'icedax':
    ensure     => installed,
  }
  package { 'id3tool':
    ensure     => installed,
  }
  package { 'id3v2':
    ensure     => installed,
  }
  package { 'pavucontrol':
    ensure     => installed,
  }
  package { 'sox':
    ensure     => installed,
  }
  package { 'tagtool':
    ensure     => installed,
  }

  ##############################################################################
  # Video Tools
  ##############################################################################

  package { 'blender':
    ensure     => installed,
  }
  package { 'cheese':
    ensure     => installed,
  }
  package { 'devede':
    ensure     => installed,
  }
  package { 'openshot':
    ensure     => installed,
  }
  package { 'openshot-doc':
    ensure     => installed,
  }
  package { 'mkvtoolnix':
    ensure     => installed,
  }
  package { 'mkvtoolnix-gui':
    ensure     => installed,
  }

  ##############################################################################
  # Web Applications & Tools
  ##############################################################################

  package { 'bluefish':
    ensure     => installed,
  }
  package { 'clamz':
    ensure     => installed,
  }
  package { 'mpack':
    ensure    => installed,
  }

  ##############################################################################
  # Web Communication Apps
  ##############################################################################

  package { 'pidgin':
    ensure     => installed,
  }
  package { 'pidgin-otr':
    ensure     => installed,
  }
  package { 'pidgin-encryption':
    ensure     => installed,
  }

  ##############################################################################
  # Virtualization
  ##############################################################################

  package { 'virtualbox-qt':
    ensure     => installed,
  }
  package { 'virtualbox-guest-additions-iso':
    ensure     => installed,
  }
  package { 'gns3':
    ensure     => installed,
  }

  ##############################################################################
  # Document tools
  ##############################################################################

  package { 'lyx':
    ensure     => installed,
  }
  package { 'pdfshuffler':
    ensure     => installed,
  }

  ##############################################################################
  # Desktop Apps
  ##############################################################################

  package { 'conky-all':
    ensure     => installed,
  }
  package { 'gtk-redshift':
    ensure     => installed,
  }
  package { 'wbar':
    ensure     => installed,
  }

  ##############################################################################
  # Google Earth
  ##############################################################################

  package { 'lsb-core':
    ensure     => installed,
  }
  package { 'googleearth':
    ensure     => installed,
  }

  ##############################################################################
  # General File Manipulation Tools
  ##############################################################################

  package { 'cabextract':
    ensure     => installed,
  }
  package { 'mdbtools':
    ensure     => installed,
  }
  package { 'mdbtools-doc':
    ensure     => installed,
  }
  package { 'mdbtools-gmdb':
    ensure     => installed,
  }
  package { 'p7zip-full':
    ensure     => installed,
  }
  package { 'rar':
    ensure     => installed,
  }
  package { 'unrar':
    ensure     => installed,
  }
  package { 'unzip':
    ensure     => installed,
  }
  package { 'zip':
    ensure     => installed,
  }

  ##############################################################################
  # Codecs
  # Notes for Blu-ray:  http://vlc-bluray.whoknowsmy.name/
  ##############################################################################

  package { 'faac':
    ensure     => installed,
  }
  package { 'flac':
    ensure     => installed,
  }
  package { 'lame':
    ensure     => installed,
  }
  package { 'libmad0':
    ensure     => installed,
  }
  package { 'libquicktime2':
    ensure     => installed,
  }
  package { 'totem-mozilla':
    ensure     => installed,
  }
  file { '/usr/lib64/libaacs.so.0':
    source     => 'puppet:///modules/mint14/common/usr/lib64/libaacs.so.0',
    mode       => '0644',
  }
  file { '/etc/skel/.config':
    ensure    => directory,
    mode      => '0755',
  }
  file { '/etc/skel/.config/aacs':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    mode      => '0755',
    source    => 'puppet:///modules/mint14/common/etc/skel/.config/aacs',
    require   => File['/etc/skel/.config'],
  }

  ##############################################################################
  # Alternate Desktops
  ##############################################################################

  package { 'cinnamon':
    ensure     => installed,
  }
  package { 'kde-plasma-desktop':
    ensure     => installed,
  }
  package { 'unity':
    ensure     => installed,
  }
  package { 'xfce4':
    ensure     => installed,
  }

  ##############################################################################
  # OpenSSH Server, Unison, and associated configurations
  ##############################################################################

  package { 'openssh-server':
    ensure     => installed,
  }
  package { 'openssh-blacklist':
    ensure     => installed,
  }
  package { 'openssh-blacklist-extra':
    ensure     => installed,
  }
  package { 'ssh-import-id':
    ensure     => installed,
  }
  package { 'unison':
    ensure     => installed,
  }
  package { 'unison-gtk':
    ensure     => installed,
  }
  file { '/etc/ssh/sshd_config':
    source     => 'puppet:///modules/mint14/common/etc/ssh/sshd_config',
    mode       => '0640',
    notify     => Service['ssh'],
    require    => Package['openssh-server'],
  }
  file { '/root/.ssh':
    ensure    => directory,
    mode      => '0700',
  }
  file { '/root/.ssh/authorized_keys':
    source     => 'puppet:///modules/mint14/common/root/.ssh/authorized_keys',
    mode       => '0600',
    require    => File['/root/.ssh'],
  }
  service { 'ssh':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  ##############################################################################
  # NFS client and Autofs with associated configurations
  ##############################################################################

  package { 'nfs-common':
    ensure     => installed,
  }
  package { 'autofs':
    ensure     => installed,
  }
  file { '/etc/idmapd.conf':
    mode       => '0644',
    source     => 'puppet:///modules/mint14/common/etc/idmapd.conf',
    require    => Package['nfs-common'],
  }
  file { '/etc/default/nfs-common':
    mode       => '0644',
    source     => 'puppet:///modules/mint14/common/etc/default/nfs-common',
    require    => Package['nfs-common'],
  }

  ##############################################################################
  # User Avatar Photos (purge => false to just put avatars in place)
  ##############################################################################

  file { '/usr/share/pixmaps/faces':
    ensure    => directory,
    recurse   => true,
    purge     => false,
    mode      => '0644',
    source    => 'puppet:///modules/mint14/common/usr/share/pixmaps/faces',
  }

  ##############################################################################
  # MDM Theme related stuff
  ##############################################################################

  file { '/usr/share/mdm/themes/Doe-GDM':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    mode      => '0755',
    source    => 'puppet:///modules/mint14/common/usr/share/mdm/themes/Doe-GDM',
  }
  file { '/etc/mdm/mdm.conf':
    source     => 'puppet:///modules/mint14/common/etc/mdm/mdm.conf',
    mode       => '0644',
  }

  ##############################################################################
  # Scripts present on all systems
  ##############################################################################

  file { '/usr/local/bin':
    ensure     => directory,
    recurse    => true,
    purge      => false,
    source     => 'puppet:///modules/mint14/common/usr/local/bin',
    mode       => '0755',
  }

  ##############################################################################
  # Local puppet installation files
  ##############################################################################

  file { '/usr/local/puppet-pkgs':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    mode      => '0755',
    source    => 'puppet:///modules/mint14/common/usr/local/puppet-pkgs',
  }

  ##############################################################################
  # Keep /tmp in RAM
  ##############################################################################

  mount { '/tmp':
    ensure    => mounted,
    atboot    => true,
    device    => 'none',
    fstype    => 'tmpfs',
    options   => 'rw,nosuid,nodev,mode=01777',
  }

  ##############################################################################
  # CACKEY installation files and directory prerequisites
  ##############################################################################

  file { '/usr/lib64':
    ensure    => directory,
    mode      => '0755',
  }
  package { 'cackey':
    ensure    => latest,
    provider  => dpkg,
    source    => '/usr/local/puppet-pkgs/cackey_0.6.5-1_amd64.deb',
    require   => [ File['/usr/lib64'], File['/usr/local/puppet-pkgs'] ],
  }

  ##############################################################################
  # SCM Smart Card Drivers in place
  ##############################################################################

  file { '/usr/local/scm':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    source    => 'puppet:///modules/mint14/common/usr/local/scm',
  }

  file { '/usr/local/pcsc':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    source    => 'puppet:///modules/mint14/common/usr/local/pcsc',
  }

  file { '/usr/local/lib/pcsc':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    source    => 'puppet:///modules/mint14/common/usr/local/lib/pcsc',
  }

  ##############################################################################
  # Truecrypt binary and support files in place
  ##############################################################################

  file { '/usr/bin/truecrypt':
    source     => 'puppet:///modules/mint14/common/usr/bin/truecrypt',
    mode       => '0755',
  }

  file { '/usr/bin/truecrypt-uninstall.sh':
    source     => 'puppet:///modules/mint14/common/usr/bin/truecrypt-uninstall.sh',
    mode       => '0754',
  }

  file { '/usr/share/applications/truecrypt.desktop':
    source     => 'puppet:///modules/mint14/common/usr/share/applications/truecrypt.desktop',
    mode       => '0644',
  }

  file { '/usr/share/pixmaps/truecrypt.xpm':
    source     => 'puppet:///modules/mint14/common/usr/share/pixmaps/truecrypt.xpm',
    mode       => '0644',
  }

  file { '/usr/share/truecrypt':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    mode      => '0644',
    source    => 'puppet:///modules/mint14/common/usr/share/truecrypt',
  }
}

class mint14::devel {

  ##############################################################################
  # Development Stuff only
  ##############################################################################

}

class mint14::silverstone {

  ##############################################################################
  # Silverstone Specific
  ##############################################################################

  apt::ppa { 'ppa:zfs-native/stable': }
  package { 'ubuntu-zfs':
    ensure     => installed,
  }

  package { 'mediatomb':
    ensure     => installed,
  }
  package { 'boinc':
    ensure     => installed,
  }

  file { '/etc/cron.daily/rollingsnap':
    mode       => '0755',
    source     => 'puppet:///modules/mint14/silverstone/etc/cron.daily/rollingsnap',
  }
}

class mint14::coolermaster {

  ##############################################################################
  # Coolermaster Specific
  ##############################################################################

  file { '/etc/auto.master':
    mode       => '0644',
    source     => 'puppet:///modules/mint14/coolermaster/etc/auto.master',
    notify     => Service['autofs'],
    require    => Package['autofs'],
  }

  file { '/etc/auto.home':
    mode       => '0644',
    source     => 'puppet:///modules/mint14/coolermaster/etc/auto.home',
    notify     => Service['autofs'],
    require    => Package['autofs'],
  }

  service { 'autofs':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
