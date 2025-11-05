# Manual module handling
# 
# Kernel modules are handled by tools provided by kmod package. You can use these tools manually.
# Note: If you have upgraded your kernel but have not yet rebooted, modprobe will fail with no 
# error message and exit with code 1, because the path /lib/modules/$(uname -r)/ no longer exists. 
# Check manually if this path exists when modprobe failed to determine if this is the case.
# 
# To load a module:
# 
# # modprobe module_name
# 
# To load a module by filename (i.e. one that is not installed in /lib/modules/$(uname -r)/):
# 
# # insmod filename [args]
# 
# To unload a module:
# 
# # modprobe -r module_name
# 
# Or, alternatively:
# 
# # rmmod module_name


