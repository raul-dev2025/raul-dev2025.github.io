## TODO: Hay que estudiar esto. 

---
lsblk - no necesita permisos para visualizar un mapa de arbol de las particiones
activas, y dispositivos como sr0(CD-ROM) mapeados en el sistema.
---
dmsetup
dmsetup help
dmsetup stats


Unknown stats command.
Usage:

dmsetup stats
        [-h|--help]
        [-v|--verbose [-v|--verbose ...]]
        [--areas <nr_areas>] [--areasize <size>]
        [--auxdata <data>] [--clear]
        [--count <count>] [--interval <seconds>]
        [-o <fields>] [-O|--sort <sort_fields>]
	      [--programid <id>]
        [--start <start>] [--length <length>]
        [--segments] [--units <units>]

	help 
	clear --regionid <id> [<device>]
	create [--start <start> [--length <len>]]
		[--areas <nr_areas>] [--areasize <size>] 
		[--programid <id>] [--auxdata <data> ] [<device>]
	delete --regionid <id> <device>
	list [--programid <id>] [<device>]
	print [--clear] [--programid <id>] [--regionid <id>] [<device>]
	report [--interval <seconds>] [--count <cnt>]
		[--units <u>][--programid <id>] [--regionid <id>] [<device>]
	version 
<device> may be device name or -u <uuid> or -j <major> -m <minor>
<fields> are comma-separated.  Use 'help -c' for list.

Mapped Device Name Fields
-------------------------
  name_all              - All fields in this section.
  name                  - Name of mapped device.
  mangled_name          - Mangled name of mapped device.
  unmangled_name        - Unmangled name of mapped device.
  uuid                  - Unique (optional) identifier for mapped device.
  mangled_uuid          - Mangled unique (optional) identifier for mapped device.
  unmangled_uuid        - Unmangled unique (optional) identifier for mapped device.
  read_ahead            - Read ahead value.
 
Mapped Device Information Fields
--------------------------------
  info_all              - All fields in this section.
  blkdevname            - Name of block device.
  attr                  - (L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.
  tables_loaded         - Which of the live and inactive table slots are filled.
  suspended             - Whether the device is suspended.
  readonly              - Whether the device is read-only or writeable.
  devno                 - Device major and minor numbers
  major                 - Block device major number.
  minor                 - Block device minor number.
  open                  - Number of references to open device, if requested.
  segments              - Number of segments in live table, if present.
  events                - Number of most recent event.
 
Mapped Device Relationship Information Fields
---------------------------------------------
  deps_all              - All fields in this section.
  device_count          - Number of devices used by this one.
  devs_used             - List of names of mapped devices used by this one.
  devnos_used           - List of device numbers of devices used by this one.
  blkdevs_used          - List of names of block devices used by this one.
  device_ref_count      - Number of mapped devices referencing this one.
  names_using_dev       - List of names of mapped devices using this one.
  devnos_using_dev      - List of device numbers of mapped devices using this one.
 
Mapped Device Name Components Fields
------------------------------------
  splitname_all         - All fields in this section.
  subsystem             - Userspace subsystem responsible for this device.
  vg_name               - LVM Volume Group name.
  lv_name               - LVM Logical Volume name.
  lv_layer              - LVM device layer.
 
Mapped Device Statistics Fields
-------------------------------
  stats_all             - All fields in this section.
  read_count            - Count of reads completed.
  reads_merged_count    - Count of read requests merged.
  read_sector_count     - Count of sectors read.
  read_time             - Accumulated duration of all read requests (ns).
  write_count           - Count of writes completed.
  writes_merged_count   - Count of write requests merged.
  write_sector_count    - Count of sectors written.
  write_time            - Accumulated duration of all writes (ns).
  in_progress_count     - Count of requests currently in progress.
  io_ticks              - Nanoseconds spent servicing requests.
  queue_ticks           - Total nanoseconds spent in queue.
  read_ticks            - Nanoseconds spent servicing reads.
  write_ticks           - Nanoseconds spent servicing writes.
  reads_merged_per_sec  - Read requests merged per second.
  writes_merged_per_sec - Write requests merged per second.
  reads_per_sec         - Reads per second.
  writes_per_sec        - Writes per second.
  read_size_per_sec     - Size of data read per second.
  write_size_per_sec    - Size of data written per second.
  avg_request_size      - Average request size.
  queue_size            - Average queue size.
  await                 - Averate wait time.
  read_await            - Averate read wait time.
  write_await           - Averate write wait time.
  throughput            - Throughput.
  service_time          - Service time.
  util                  - Utilization.
  hist_count            - Latency histogram counts.
  hist_count_bounds     - Latency histogram counts with bin boundaries.
  hist_count_ranges     - Latency histogram counts with bin ranges.
  hist_percent          - Relative latency histogram.
  hist_percent_bounds   - Relative latency histogram with bin boundaries.
  hist_percent_ranges   - Relative latency histogram with bin ranges.
  interval_ns           - Sampling interval in nanoseconds.
  interval              - Sampling interval.
 
Mapped Device Statistics Region Information Fields
--------------------------------------------------
  region_all            - All fields in this section.
  region_id             - Region ID.
  region_start          - Region start.
  region_len            - Region length.
  area_id               - Area ID.
  area_start            - Area offset from start of device.
  area_len              - Area length.
  area_offset           - Area offset from start of region.
  area_count            - Area count.
  program_id            - Program ID.
  aux_data              - Auxiliary data.
  precise               - Set if nanosecond precision counters are enabled.
  hist_bins             - The number of histogram bins configured.
  hist_bounds           - Latency histogram bin boundaries.
  hist_ranges           - Latency histogram bin ranges.
 
Special Fields
--------------
  selected              - Set if item passes selection criteria.
  help                  - Show help.
  ?                     - Show help.

