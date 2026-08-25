:orphan:

============
ScullC ioctl
============

.. code-block:: C

   long scullc_ioctl(struct file *filp,
                     unsigned int cmd, unsigned long arg)
   {

   int err = 0, ret = 0, tmp;

   /* don't even decode wrong cmds: better returning  ENOTTY than EFAULT */
   if (_IOC_TYPE(cmd) != SCULLC_IOC_MAGIC)
      return -ENOTTY;
   if (_IOC_NR(cmd) > SCULLC_IOC_MAXNR)
      return -ENOTTY;

   /*
      * the type is a bitmask, and VERIFY_WRITE catches R/W
      * transfers. Note that the type is user-oriented, while
      * verify_area is kernel-oriented, so the concept of "read" and
      * "write" is reversed
      */
   if (_IOC_DIR(cmd) & _IOC_READ)
      err = !access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd));
   else if (_IOC_DIR(cmd) & _IOC_WRITE)
      err = !access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
   if (err)
      return -EFAULT;

   switch (cmd)
   {

   case SCULLC_IOCRESET:
      scullc_qset = SCULLC_QSET;
      scullc_quantum = SCULLC_QUANTUM;
      break;

   case SCULLC_IOCSQUANTUM: /* Set: arg points to the value */
      ret = __get_user(scullc_quantum, (int __user *)arg);
      break;

   case SCULLC_IOCTQUANTUM: /* Tell: arg is the value */
      scullc_quantum = arg;
      break;

   case SCULLC_IOCGQUANTUM: /* Get: arg is pointer to result */
      ret = __put_user(scullc_quantum, (int __user *)arg);
      break;

   case SCULLC_IOCQQUANTUM: /* Query: return it (it's positive) */
      return scullc_quantum;

   case SCULLC_IOCXQUANTUM: /* eXchange: use arg as pointer */
      tmp = scullc_quantum;
      ret = __get_user(scullc_quantum, (int __user *)arg);
      if (ret == 0)
         ret = __put_user(tmp, (int __user *)arg);
      break;

   case SCULLC_IOCHQUANTUM: /* sHift: like Tell + Query */
      tmp = scullc_quantum;
      scullc_quantum = arg;
      return tmp;

   case SCULLC_IOCSQSET:
      ret = __get_user(scullc_qset, (int __user *)arg);
      break;

   case SCULLC_IOCTQSET:
      scullc_qset = arg;
      break;

   case SCULLC_IOCGQSET:
      ret = __put_user(scullc_qset, (int __user *)arg);
      break;

   case SCULLC_IOCQQSET:
      return scullc_qset;

   case SCULLC_IOCXQSET:
      tmp = scullc_qset;
      ret = __get_user(scullc_qset, (int __user *)arg);
      if (ret == 0)
         ret = __put_user(tmp, (int __user *)arg);
      break;

   case SCULLC_IOCHQSET:
      tmp = scullc_qset;
      scullc_qset = arg;
      return tmp;

   default: /* redundant, as cmd was checked against MAXNR */
      return -ENOTTY;
   }

   return ret;
   }

   loff_t scullc_llseek(struct file *filp, loff_t off, int whence)
   {
   struct scullc_dev *dev = filp->private_data;
   long newpos;

   switch (whence)
   {
   case 0: /* SEEK_SET */
      newpos = off;
      break;

   case 1: /* SEEK_CUR */
      newpos = filp->f_pos + off;
      break;

   case 2: /* SEEK_END */
      newpos = dev->size + off;
      break;

   default: /* can't happen */
      return -EINVAL;
   }
   if (newpos < 0)
      return -EINVAL;
   filp->f_pos = newpos;
   return newpos;
   }