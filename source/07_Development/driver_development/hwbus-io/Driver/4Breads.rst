===========
Lectura Pci
===========

Propuesta de lectura para campo pci
===================================



:orpahn:

.. code-block:: C

   #include <hwbus_param.h>
   #include <linux/pci.h>

   #include <sysfs_driver.h>

   ssize_t hwbus_pci_config_read(struct file *filp, char __user *buf,
                                 size_t count, loff_t *f_pos)
   {
   struct pci_dev *pdev = hwbus_get_pci_dev_from_param();
   u8 data[4];
   u16 vendor, device;
   size_t bytes_to_copy;

   if (!pdev)
      return -ENODEV;

   if (*f_pos >= 4)
      return 0;

   pci_read_config_word(pdev, PCI_VENDOR_ID, &vendor);
   pci_read_config_word(pdev, PCI_DEVICE_ID, &device);

   data[0] = vendor & 0xFF;
   data[1] = (vendor >> 8) & 0xFF;
   data[2] = device & 0xFF;
   data[3] = (device >> 8) & 0xFF;

   bytes_to_copy = 4 - *f_pos;
   if (bytes_to_copy > count)
      bytes_to_copy = count;

   if (copy_to_user(buf, data + *f_pos, bytes_to_copy))
      return -EFAULT;

   *f_pos += bytes_to_copy;
   return bytes_to_copy;
   }