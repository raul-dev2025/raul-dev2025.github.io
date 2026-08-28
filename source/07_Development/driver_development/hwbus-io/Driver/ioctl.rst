==========
Test ioctl
==========




.. code-block:: c

   #include <fcntl.h>
   #include <inttypes.h>
   #include <stdint.h>
   #include <stdio.h>
   #include <stdlib.h>
   #include <sys/ioctl.h>
   #include <sys/stat.h>
   #include <sys/types.h>
   #include <unistd.h>

   #include "tst_test.h"
   #include "hwbus-io.h"

   #define DEV_PATH "/dev/hwbusc"
   #define SYSFS_PCI_PATH "/sys/bus/pci/devices/0000:02:00.0/"

   static int fd = -1;

   static uint16_t read_sysfs_hex16(const char *rel_path)
   {
      FILE *fp;
      uint16_t val = 0;
      char full_path[256];

      snprintf(full_path, sizeof(full_path), "%s%s", SYSFS_PCI_PATH, rel_path);
      fp = fopen(full_path, "r");
      if (!fp)
         tst_brk(TBROK | TERRNO, "Failed to open %s", full_path);

      if (fscanf(fp, "0x%" SCNx16, &val) != 1) {
         fclose(fp);
         tst_brk(TBROK, "Failed to parse hex value from %s", full_path);
      }

      fclose(fp);
      return val;
   }

   static uint8_t read_sysfs_hex8(const char *rel_path)
   {
      FILE *fp;
      unsigned int val = 0;
      char full_path[256];

      snprintf(full_path, sizeof(full_path), "%s%s", SYSFS_PCI_PATH, rel_path);
      fp = fopen(full_path, "r");
      if (!fp)
         tst_brk(TBROK | TERRNO, "Failed to open %s", full_path);

      if (fscanf(fp, "0x%x", &val) != 1) {
         fclose(fp);
         tst_brk(TBROK, "Failed to parse hex value from %s", full_path);
      }

      fclose(fp);
      return (uint8_t)val;
   }

   static void setup(void)
   {
      fd = open(DEV_PATH, O_RDWR);
      if (fd < 0)
         fd = open(DEV_PATH, O_RDONLY);

      if (fd < 0)
         tst_brk(TBROK | TERRNO, "Failed to open %s", DEV_PATH);
   }

   static void cleanup(void)
   {
      if (fd >= 0)
         close(fd);
   }

   static void test_pci_ids_ioctl(void)
   {
      uint16_t exp_vendor = read_sysfs_hex16("vendor");
      uint16_t exp_device = read_sysfs_hex16("device");
      uint16_t act_vendor = 0, act_device = 0;

      if (ioctl(fd, HWBUS_IOC_READ_VENDOR, &act_vendor) < 0) {
         tst_res(TFAIL | TERRNO, "HWBUS_IOC_READ_VENDOR ioctl failed");
         return;
      }

      if (ioctl(fd, HWBUS_IOC_READ_DEVICE, &act_device) < 0) {
         tst_res(TFAIL | TERRNO, "HWBUS_IOC_READ_DEVICE ioctl failed");
         return;
      }

      if (act_vendor == exp_vendor && act_device == exp_device) {
         tst_res(TPASS, "IOCTL PCI IDs match SysFS (Vendor: 0x%04x, Device: 0x%04x)",
            act_vendor, act_device);
      } else {
         tst_res(TFAIL, "IOCTL PCI IDs mismatch: got Vendor=0x%04x Device=0x%04x, exp Vendor=0x%04x Device=0x%04x",
            act_vendor, act_device, exp_vendor, exp_device);
      }
   }

   static void test_data_widths(void)
   {
      uint8_t exp_rev = read_sysfs_hex8("revision");
      uint8_t act_rev = 0;
      uint16_t cmd_reg = 0;
      uint32_t bar0_reg = 0;

      /* 8-bit read (Revision ID at offset 0x08) */
      if (ioctl(fd, HWBUS_IOC_READ_REVISION, &act_rev) < 0) {
         tst_res(TFAIL | TERRNO, "8-bit IOCTL read failed");
      } else if (act_rev == exp_rev) {
         tst_res(TPASS, "8-bit IOCTL read (Revision ID: 0x%02x) matches SysFS", act_rev);
      } else {
         tst_res(TFAIL, "8-bit IOCTL read mismatch: got 0x%02x, expected 0x%02x", act_rev, exp_rev);
      }

      /* 16-bit read (Command Register at offset 0x04) */
      if (ioctl(fd, _IOR('L', 0x04, uint16_t), &cmd_reg) < 0) {
         tst_res(TFAIL | TERRNO, "16-bit IOCTL read (Command Reg) failed");
      } else {
         tst_res(TPASS, "16-bit IOCTL read executed successfully (Cmd: 0x%04x)", cmd_reg);
      }

      /* 32-bit read (BAR0 Register at offset 0x10) */
      if (ioctl(fd, _IOR('L', 0x10, uint32_t), &bar0_reg) < 0) {
         tst_res(TFAIL | TERRNO, "32-bit IOCTL read (BAR0) failed");
      } else {
         tst_res(TPASS, "32-bit IOCTL read executed successfully (BAR0: 0x%08x)", bar0_reg);
      }
   }

   static void test_invalid_ioctl(void)
   {
      uint32_t dummy = 0;
      unsigned int invalid_cmd = _IOR('L', 0xFF, uint32_t); // Offset fuera de rango (> 0x3c)

      TST_EXP_FAIL(ioctl(fd, invalid_cmd, &dummy), ENOTTY, "Invalid IOCTL command rejection");
   }

   static void run_tests(void)
   {
      test_pci_ids_ioctl();
      test_data_widths();
      test_invalid_ioctl();
   }

   static struct tst_test test = {
      .setup = setup,
      .cleanup = cleanup,
      .test_all = run_tests,
   };