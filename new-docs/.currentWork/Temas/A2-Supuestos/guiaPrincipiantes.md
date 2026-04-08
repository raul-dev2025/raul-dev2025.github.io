
wiki.xenproject.org
Xen Project Beginners Guide - Xen
26-33 minutes

Welcome!

This guide was written to introduce beginners to basic Xen Project concepts and allow you to get started with Xen Project with no prior knowledge. Some prior Linux experience is required however, knowledge of networking, lvm and grub will go a long way!

By completing this guide you will have installed a fully functional Xen Project hypervisor and started your first guest operating systems, connected them to your network and have been introduced to fundamental concepts such as virtual machine storage and virtual networking.

To make this process easy we will be using a Linux distribution called Debian. This document was originally written for use with Debian 7.0 (called “Wheezy”) or the previous 6.0 release (called “Squeeze”), however the instructions should work for newer releases (like 8.0 "Jessie") as well. Debian ships with support for Xen Project release 4.0 (Squeeze), 4.1 (Wheezy), or 4.4 (Jessie), providing everything you need to get started!

Though this guide looks long at first, don’t become daunted. It is very in-depth and comprehensive, but doesn’t expect you to know all that much beforehand. The goal instead is to teach you all the things you need to know to build a functioning Xen Project Hypervisor. :)

Xen Project creates a Virtual Machine Monitor (VMM) also known as a hypervisor, this is a software system that allows the execution of multiple virtual guest operating systems simultaneously on a single physical machine. In particular, the project creates a Type 1 or “bare-metal” hypervisor, meaning that it runs directly on top of the physical machine as opposed to within an operating system.

Guest virtual machines running on a Xen Project Hypervisor are known as “domains” and a special domain known as dom0 is responsible for controlling the hypervisor and starting other guest operating systems. These other guest operating systems are called domUs, this is because these domains are “unprivileged” in the sense they cannot control the hypervisor or start/stop other domains.

Our hypervisor supports two primary types of virtualization: para-virtualization and hardware virtual machine (HVM) also known as “full virtualization”. Para-virtualization uses modified guest operating systems that we refer to as enlightened guests. These operating systems are aware that they are being virtualized and as such don’t require virtual “hardware” devices, instead they make special calls to the hypervisor that allow them to access CPUs, storage and network resources.

In contrast HVM guests need not be modified as the hypervisor will create a fully virtual set of hardware devices for this machine that resemble a physical x86 computer. This emulation requires much more overhead than the paravirtualisation approach but allows unmodified guest operating systems like Microsoft Windows to run on top of the hypervisor. HVM support requires special CPU extensions - VT-x for Intel processors and AMD-V for AMD based machines. This technology is now prevalent and all recent servers and desktop systems should be equipped with them.

A third type of virtualization though not discussed in this guide is called PVHVM or “Para-virtualisation on HVM” which is a HVM domain with paravirtualized storage, network and other devices. This provides the best of both worlds by reducing expensive emulation but providing hardware accelerated CPU and memory access.

To understand how storage, networking and other resources are delivered to guest systems we need to quickly delve into how the different bits of the software interact.


XenArch1.png

This is the basic architecture of the Xen Project Hypervisor. We see that the hypervisor sits on the bare metal (the actual computer hardware). We see the guest VMs all sit on the hypervisor layer, as does the "Control Domain" (also called "Dom0"). The Control Domain is a VM like the guest VMs, except that it has two basic functional differences:

1. The Control Domain has the ability to talk to the hypervisor to instruct it to start and stop guest VMs.

2. The Control Domain by default contains the device drivers needed to address the hardware. This stops the problem that often plagued Linux users in the 1990s: You install your software on a new piece of hardware, only to find that you lack the drivers to use it. Since those early days, Linux and the BSDs have become quite good at supporting more pieces of hardware fairly quickly after they are birthed. Xen Project leverages that support by using the drivers in the Control Domain's operating system to access many types of hardware.

XenArch2.png


The dom0 forms the interface to the hypervisor, through special instructions the dom0 communicates to the Xen Project software and changes the configuration of the hypervisor. This includes instantiating new domains and related tasks.

Another crucial part of the dom0’s role is that it is the primary interface to the hardware. The hypervisor doesn’t contain device drivers, instead the devices are attached to dom0 and you can use standard Linux drivers. Dom0 then shares these resources with guest operating systems through a number of paravirtualized devices.

Each para-virtualized datapath consists of 2 parts: 1) the a “backend” that lives in dom0, which provides the virtual device and 2) the “frontend” driver within the guest domain, which allows the guest OS to access the virtual device. The backend and frontend use a high-speed software interface based on shared memory to transfer data between the guest and dom0.

The two important paravirtualized datapaths are: net-back/net-front, and blk-back/blk-front - which are the paravirtualized networking and storage systems, respectively. There are also paravirtualized

You can read more about how the Xen Project system is architected, paravirtualization and the benefits of such here:

    Details of Paravirtualization (PV) and how it is used on Xen Project
    An explanation of the Virtualization Spectrum on hypervisors and how the various modes (PV, HVM, etc.) fit into the picture

This guide requires a number of items, this checklist is what you will need:

    64bit x86 computer with at least 1GB of RAM (this can be a server, desktop or laptop!)
    (Optional) VT-d or AMD-V support
    Sufficient storage space for your dom0 and whatever guests you want to install
    A CD burner + blank CD (you can use a USB but this is not covered here)
    Internet access for downloading and installing Debian
    (Optional) Windows Server 2008R2 installation ISO, a trial copy is sufficient
    (Optional) VNC client for installing HVM domain

Enable virtualization support in BIOS

NOTE: This is optional and not required for PV guests, however it is recommended so that you have the widest number of options for virtualization modes once you get underway.

In order to support HVM guests we need to ensure that virtualization extensions are enabled in the BIOS. If you don’t wish to start a HVM guest you can skip this step but it is still highly recommended. If your system doesn’t support these extensions you cannot use the hypervisor to virtualize unmodified operating systems, however para-virtualization will work fine.

The virtualization option appears differently in different BIOS builds but generally it is referred to as “Enable Virtualisation Technology” or “Enable Intel VT” for Intel chipsets, however in some cases it can be listed as “Vanderpool Technology”. Oftentimes this option can be found under the “Advanced Chipset Features” menu in the BIOS. Similar also for AMD.

Consult your motherboard documentation for more assistance in enabling virtualization extensions on your system.
Download and Burn the Debian Installer CD

You can find the most recent Debian ISO images at this URL:

   http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/

The netinst image is sufficient for our purposes.

Burn the ISO to disk using your computer's standard utilities. I recommend wodim on Linux or the built in ISO burning feature in Windows.
Quick intro to Debian

Debian is a simple, stable and well supported Linux distribution. It has included Xen Project Hypervisor support since Debian 3.1 “Sarge” released in 2005.

Debian uses the simple Apt package management system which is both powerful and simple to use. Installing a package is as simple as the following example:

   apt-get install htop

Where htop was the application desired to install.

Simple tasks such as configuring startup scripts, setting up the network etc are covered by this tutorial so don’t worry if you haven’t used Debian before!

Many popular distributions are based off of Debian and also use the Apt package manager, if you have used Ubuntu, Linux Mint or Damn Small Linux you will feel right at home.

Boot the Debian Installer CD Insert the Debian CD and configure the CDROM drive as your default boot device in the BIOS or use the system boot menu if your BIOS supports it (usually F12).

You should see a menu, choose the default “Install” option to begin the installation process. Install the system The Debian installer is very straight forward. Follow the prompts until you reach the disk partitioning section.

Choose advanced/custom, we are going to configure a few partitions here, one for /boot another for /, one more for swap and a final partition to setup as an LVM volume group for our guest machines.

First create the /boot partition by choosing the disk and hitting enter, make the partition 300MB and format it as ext2, choose /boot as the mountpoint.

Repeat the process for / but of course changing the mountpoint to / and making it 15GB or so large. Format it as ext3.

Create another partition approximately 1.5x the amount of RAM you have in size and elect to have it used as a swap volume.

Finally create a partition that consumes the rest of the diskspace but don’t format it or assign a mount point.

We should now have a layout that looks like this assuming your disk device is /dev/sda :

   sda1 - /boot 200MB
   sda2 - / 15GB
   sda3 - swap
   sda4 - reserved for LVM

When you reach the package selection stage only install the base system, we won’t require any GUI or other packages for this guide.

You can find out details of the Debian installation process from the Debian documentation.

Continue through the installer then reboot and login at the prompt as root.

If you've got any hardware you're not sure open source drivers are available for, you may want to install non-free firmware files via:

   apt-get install firmware-linux-nonfree

If this does not work straight away make sure your /etc/apt/sources.list has entries including non-free and perhaps contrib while you're at it, e.g. like this:

   deb http://some.debian.server.org/debian wheezy main contrib non-free

Add the same to deb-src and the wheezy/updates lines (or squeeze/updates if that's what you're using).

LVM is the Linux Logical Volume manager. It is a technology that allows Linux to manage block devices in a more abstract manner.

LVM introduces the concept of a “logical volume”, effectively a virtualized block device composed of blocks written to 1 or more physical devices. These blocks don’t need to be contiguous unlike proper disk partitions.

Because of this abstraction logical volumes can be created, deleted, resized and even snapshotted without affecting other logical volumes.

LVM creates logical volumes within what is called a volume group, which is simply a set of logical volumes that share the same physical storage, known as physical volumes.

The process of setting up LVM can be summarized as allocating a physical volume, creating a volume group on top of this, then creating logical volumes to store data.

Because of these features and superior performance over file backed virtual machines I recommend the use of LVM if you are going to store VM data locally.

Now lets install LVM and get started!

Install LVM:

   apt-get install lvm2

Now that we have LVM installed let's configure it to use /dev/sda4 as its physical volume

   pvcreate /dev/sda4

Ok, now LVM has somewhere to store its blocks (known as extents for future reference). Let's create a volume group called ‘vg0’ using this physical volume:

   vgcreate vg0 /dev/sda4

Now LVM is setup and initialized so that we can later create logical volumes for our virtual machines.

For the interested below is a number of useful commands and tricks when using LVM.

Create a new logical volume:

   lvcreate -n<name of the volume> -L<size, you can use G and M here> <volume group>

For example, creating a 100 gigabyte volume called database-data on a volume group called vg0.

   lvcreate -ndatabase-data -L100G vg0

You can then remove this volume with the following:

   lvremove /dev/vg0/database-data

Note that you have to provide the path to the volume here.

If you already have a volume setup that you would like to copy, LVM has a cool feature that allows you to create a CoW (copy on write) clone called a snapshot. This means that you can make an "instant" copy that will only store the changes compared to the original. There are a number of caveats to this that will be discussed in a yet unwritten article. The most important thing to note is that the "size" of the snapshot is only the amount of space allocated to store changes. So you can make the snapshot "size" a lot smaller than the source volume.

To create a snapshot use the following command:

   lvcreate -s /dev/vg0/database-data -ndatabase-backup -L5G

Once again note the use of the full path.

Next we need to setup our system so that we can attach virtual machines to the external network. This is done by creating a virtual switch within dom0 that takes packets from the virtual machines and forwards them onto the physical network so they can see the internet and other machines on your network.

The piece of software we use to do this is called the Linux bridge and its core components reside inside the Linux kernel. In this case the “bridge” is effectively our virtual switch. Our Debian kernels are compiled with the Linux bridging module so all we need to do is install the control utilities.

   apt-get install bridge-utils

Instead of calling brctl directly we are instead going to configure our bridge through Debian’s networking infrastructure which can be configured via /etc/network/interfaces.

Open this file with the editor of your choice. If you selected a minimal installation, the nano text editor should already be installed. Open the file:

   nano /etc/network/interfaces

Depending on your hardware you probably see a file pretty similar to this:

    auto lo
    iface lo inet loopback

    auto eth0
    iface eth0 inet dhcp

This file is very simple. Each stanza represents a single interface. Breaking it down “auto eth0” means that eth0 will be configured when ifup -a is run (which is run a boot time) what this means is that the interface will automatically be started/stopped for you. “iface eth0” then describes the interface itself, in this case it merely specifies that it should be configured by DHCP - we are going to assume that you have DHCP running on your network for this guide. If you are using static addressing you probably know how to set that up. We are going to edit this file so it resembles such:

    auto lo
    iface lo inet loopback

    auto eth0
    iface eth0 inet dhcp
    
    auto xenbr0
    iface xenbr0 inet dhcp
        bridge_ports eth0

Now restart networking (make sure you have a backup way to access the host if this fails):

    service networking restart

And check to make sure that it worked:

    brctl show

Bridged networking will now start automatically every boot. You will need to reboot before continuing.

The Debian Xen Project packages consist primarily of a Xen Project-enabled Linux kernel, the hypervisor itself, a modified version of QEMU that support the hypervisor’s HVM mode and a set of userland tools.

All of this except QEMU can be installed via an Apt meta-package called xen-linux-system. A meta-package is basically a way of installing a group of packages automatically. Apt will of course resolve all dependencies and bring in all the extra libraries we need.

Let's install the xen-linux-system metapackage:

   apt-get -P install xen-linux-system

Next we will install the Xen Project QEMU package so that we can boot HVM guests later (this is optional but highly recommended)

   apt-get install xen-qemu-dm  # only needed for Squeeze, not for Wheezy

Note that on Ubuntu the package name is different, so the installation line may look more like:

   apt-get install xen-hypervisor-4.4-amd64

Now we have a Xen Project hypervisor, a Xen Project kernel and the userland tools installed, almost ready to go.

Because the hypervisor starts before your operating system we need to change how your systems boot process is setup. The bootloader installed during installation called GRUB is what tells your computer which operating system to start and how.

GRUB2 configuration is stored in the file /boot/grub/grub.cfg However we aren’t going to edit this file directly, as it changes every time we update our kernel. Debian configures GRUB for us using a number of automated scripts that handle upgrades etc, these scripts are stored in /etc/grub.d/* and are configured via

   /etc/default/grub

We are going to change the order of the operating systems so that our hypervisor is the default option. By executing the below command we are moving the hypervisor to a higher priority than default Linux so that it gets the first position in the boot menu.

   dpkg-divert --divert /etc/grub.d/08_linux_xen --rename /etc/grub.d/20_linux_xen

We then generate the /boot/grub/grub.cfg file by running the command below:

   update-grub

Enable the Xen network bridge by editing

   /etc/xen/xend-config.sxp

and un-comment the line

   (network-script network-bridge)

Reboot and the default boot option will be our dom0 running on top of the hypervisor!

See also

    Xen Project GRUB Boot Options

Before we dive into creating some guest domains we will quickly cover some basic commands. In the examples below, we use xl command line tool. Older versions of the Xen Project software, and many distributions still use the xm command line tool (e.g. Debian Squeeze and Wheezy). The table below shows which command to use
Xen Project version 	XM / XL
Xen Project 4.1 and prior 	xm is the recommended toolstack
Xen Project 4.2 to 4.4 	xm is deprecated, and xl is available
Xen Project 4.5 and newer 	Only xl is available

You can find further information in the following articles:

    Migration Guide from xm to xl
    XM to XL: A Short, But Necessary, Journey and
    XL vs Xend Feature Comparison. 

Note that xl and xm are command line compatible, but the format of the output may be slightly different.

So lets start with simple stuff! If you are using a version of Xen Project software earlier than 4.5 (such as under Debian Wheezy or Squeeze), just replace xl with xm.

   xl info

This returns the information about the hypervisor and dom0 including version, free memory etc.

   xl list

Lists running domains, their IDs, memory, state and CPU time consumed

   xl top

Shows running domains in real time and is similar to the “top” command under Linux. This can be used to visualize CPU, memory usage and block device access.

We will cover some more commands during the creation of our guest domains.

See also:

    Xen Project 4.x Man Pages


### Creating a Debian PV (Paravirtualized) Guest ###


PV guests are notoriously “different” to install. Due to the nature of enlightened systems they don’t have the usual concepts of a CD-ROM drive installer analogous to their physical counterparts. However, luckily enough there are tools that help us prepare “images” or effectively snapshots of the operating systems that are able to run inside of guest domains.

Debian contains a number of tools for creating Xen Project guests. The easiest of which is known as xen-tools. This software suite manages the downloading and installing of guest operating systems including both Debian and RHEL based DomUs. In this guide we are going to use xen-tools to prepare a Debian paravirtualized domU.

Xen-tools can use LVM storage for storing the guest operating systems, in this guide we created the volume group “vg0” in the Setting up LVM Storage section.

When guests are paravirtualized there is no “BIOS” or bootloader resident within the guest filesystem and for a long time guests were provided with kernels external to the guest image. This however is bad for maintainability (guests cannot upgrade their kernels without access to the dom0) and is not as flexible in terms of boot options as they must be passed via the config file.

The Xen Project community wrote a utility known as pygrub which is a python application for PV guests that enables the dom0 to parse the GRUB configuration of the domU and extract its kernel, initrd and boot parameters. This allows for kernel upgrades etc inside of our guest machines along with a GRUB menu. Using pygrub or the stub-dom implementation known as pv-grub is best practice for starting PV guests. In some cases pv-grub is arguably more secure but as it is not included with Debian we won’t use it here though it is recommended in production environments where guests cannot be trusted.

Apart from this PV guests are very similar to their HVM and physical OS counterparts.
Configuring xen-tools and building our guest

First lets install the xen-tools package:

   apt-get install xen-tools

We can now create a guest operating system with this tool. It effectively automates the process of setting up a PV guest from scratch right to the point of creating config files and starting the guest. The process can be summarized as follows:

    Create logical volume for rootfs
    Create logical volume for swap
    Create filesystem for rootfs
    Mount rootfs
    Install operating system using debootstrap (or rinse etc, only debootstrap covered here)
    Run a series of scripts to generate guest config files like fstab/inittab/menu.lst
    Create a VM config file for the guest
    Generate a root password for the guest system
    Unmount the guest filesystem

These 9 steps can be carried out manually but the manual process is outside the scope of this guide. We instead will execute the below command (for --dist you could in place of Wheezy e.g. use Squeeze, or even Precise or Quantal for a Ubuntu install):

  xen-create-image --hostname=tutorial-pv-guest \
  --memory=512mb \
  --vcpus=2 \
  --lvm=vg0 \
  --dhcp \
  --pygrub \
  --dist=wheezy

This command instructs xen-create-image (the primary binary of the xen-tools toolkit) to create a guest domain with 512MB of memory, 2 vcpus, using storage from the vg0 volume group we created, use DHCP for networking, pygrub to extract the kernel from the image when booted and lastly we specify that we want to deploy a Debian Wheezy operating system.

This process will take a few minutes.

Note that xen-tools is aimed at systems administered from the command-line using xl/xm and will generate domain configuration files suitable for use with xl or xm.

Also see

    xen-create-image(8) man page
    Further articles on xen-tools

Not every distribution provides the xen-tools package for an automated PV creation and configuration. Alpine Linux is one of these distro and therefore provides detailed instructions in order to install and start a PV domU manually. This also provides valuable information regarding the startup options available.

Here is the command which you can start the guest with (again, for older versions of Xen Project software, replace xl with xm):

  xl create -c /etc/xen/tutorial-pv-guest.cfg

The -c in this command tells xl/xm that we wish to connect to the guest virtual console. Which is a paravirtualised serial port within the domain that xen-create-image configured to listen with a getty. This is analogous to running:

  xl create /etc/xen/tutorial-pv-guest.cfg && xl console tutorial-pv-guest

You can leave the guest virtual console by pressing ctrl+] and re-enter it by running the “xl console <domain>” command.

You can later shutdown this guest either from within the domain or from dom0 with the following:

  xl shutdown tutorial-pv-guest

That completes our section on setting up your first paravirtualized domain! If you don’t have any interest in setting up a HVM domain then no need to read any further but it is highly recommended!


### Creating a Windows HVM(hardware virtualized) Guest ###

HVM guests are quite a bit different to their PV counterparts. Because they require the emulation of hardware there are more moving pieces that need to be configured etc.

The main point worth mentioning here is that HVM requires the emulation of ATA, Ethernet and other devices, while virtualized CPU and Memory access is performed in hardware to achieve good performance. Because of this the default emulated devices are very slow and we generally try to use PV drivers within HVM domains. We will be installing a set of Windows PV drivers that greatly increase performance once we have our Windows guest running.

This extra emulation is provided by a Xen Project-modified version of QEMU we should have installed this earlier but in case you skipped that step install the Xen Project QEMU package now:

   # For old Debian versions on the host (up to Squeeze):
   apt-get install xen-qemu-dm
   
   # For newer Debian versions on the host:
   apt-get install qemu-system-x86

Note that later versions of Xen Project software now can use the default, unmodified QEMU software, so this step may not be needed in recent releases.

Once the necessary packages are installed we need to create a logical volume to store our Windows VM hard disk, create a config file that tells the hypervisor to start the domain in HVM mode and boot from the DVD in order to install Windows.

First, create the new logical volume - name the volume "windows", set the size to 20GB and use the volume group vg0 we created earlier.

   lvcreate -nwindows -L20G vg0

Next open a new file with your text editor of choice:

   nano windows.cfg

Paste the config below into the file and save it, NOTE this assumes your Windows iso is located in /root/ with the filename windows.iso and that you're using Squeeze (for Wheezy change the kernel line to a xen-4.1 instead of xen-4.0 folder). In Debian Jessie, please use 'qemu-xen' rather than 'qemu-xen-traditional'.

   kernel = "/usr/lib/xen-4.0/boot/hvmloader"
   builder='hvm'
   memory = 4096
   vcpus=4
   name = "ovm-1734"
   vif = ['bridge=xenbr0']
   disk = ['phy:/dev/vg0/windows,hda,w','file:/root/windows.iso,hdc:cdrom,r']
   acpi = 1
   device_model_version = 'qemu-xen-traditional'
   boot="d"
   sdl=0
   serial='pty'
   vnc=1
   vnclisten=""
   vncpasswd=""

Start the guest following the next section (Start a GUI guest) and proceed with Windows' installation.

Once you have installed Windows by formatting the disk and by following the prompts the domain will restart - however this time we want to prevent it booting from DVD so destroy the domain with

   xl destroy windows

Then change the boot line in the config file to read boot="c"' restart the domain with

   xl create windows.cfg


### Installing PV drivers for HVM guests ###


Reconnect with VNC and finish the installation. When this process is complete you should then proceed to download the GPLPV drivers for Windows by James Harper.
Installing PV drivers for HVM guests

Signed drivers can be obtained from Univention's website.

Many thanks for Univention for making signed drivers available to the Xen Project community and of course a massive thanks to James for all his work on making Windows in guest VMs such a smooth experience.

On finalizing the installation and rebooting you should notice much improved disk and network performance and the hypervisor will now be able to gracefully shutdown your Windows domains.

Another slightly different version of James Harper's drivers can be found here.

Here is the command to start the domain and connect to it via VNC from your graphical machine.

   xl create windows.cfg

The VNC display should be available on port 5900 of your dom0 IP, for instance using gvncviewer:

   gvncviewer <dom0-ip-address>:5900

If this does not work try it without the port number and if you are trying from a GUI on dom0, try specifying localhost instead of the dom0 ip:

   gvncviewer localhost

That concludes our introduction to the Xen Project software, by now you can setup both PV and HVM domains on a bare dom0 hypervisor!

You can now move onto building your own guest images or try out some prebuilt Guest VM Images.

