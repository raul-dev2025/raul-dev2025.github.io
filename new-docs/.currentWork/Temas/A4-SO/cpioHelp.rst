Usage: ./usr/gen_init_cpio [-t ]

is a file containing newline separated entries that describe the files
to be included in the initramfs archive:

a comment
=========

file [] dir nod slink pipe sock

name of the file/dir/nod/etc in the archive location of the file in the
current filesystem expands shell variables quoted with ${} link target
mode/permissions of the file user id (0=root) group id (0=root) device
type (b=block, c=character) major number of nod minor number of nod
space separated list of other links to file pipe sock

example: # A simple initramfs dir /dev 0755 0 0 nod /dev/console 0600 0
0 c 5 1 dir /root 0700 0 0 dir /sbin 0755 0 0 file /sbin/kinit
/usr/src/klibc/kinit/kinit 0755 0 0

is time in seconds since Epoch that will be used as mtime for symlinks,
special files and directories. The default is to use the current time
for these entries.
