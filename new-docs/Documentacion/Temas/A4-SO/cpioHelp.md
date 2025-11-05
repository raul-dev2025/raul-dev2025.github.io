Usage:
	./usr/gen_init_cpio [-t <timestamp>] <cpio_list>

<cpio_list> is a file containing newline separated entries that
describe the files to be included in the initramfs archive:

# a comment
file <name> <location> <mode> <uid> <gid> [<hard links>]
dir <name> <mode> <uid> <gid>
nod <name> <mode> <uid> <gid> <dev_type> <maj> <min>
slink <name> <target> <mode> <uid> <gid>
pipe <name> <mode> <uid> <gid>
sock <name> <mode> <uid> <gid>

<name>       name of the file/dir/nod/etc in the archive
<location>   location of the file in the current filesystem
             expands shell variables quoted with ${}
<target>     link target
<mode>       mode/permissions of the file
<uid>        user id (0=root)
<gid>        group id (0=root)
<dev_type>   device type (b=block, c=character)
<maj>        major number of nod
<min>        minor number of nod
<hard links> space separated list of other links to file
pipe <name> <mode> <uid> <gid>
sock <name> <mode> <uid> <gid>

example:
# A simple initramfs
dir /dev 0755 0 0
nod /dev/console 0600 0 0 c 5 1
dir /root 0700 0 0
dir /sbin 0755 0 0
file /sbin/kinit /usr/src/klibc/kinit/kinit 0755 0 0

<timestamp> is time in seconds since Epoch that will be used
as mtime for symlinks, special files and directories. The default
is to use the current time for these entries.
