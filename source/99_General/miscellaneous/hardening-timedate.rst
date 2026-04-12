Network Connectivity Troubleshooting Guide
=========================================

Initial Symptoms
------------------

- Commands like ``ping pool.ntp.org`` freeze the console
- ``ping -c 4 8.8.8.8`` times out
- ``curl -I http://pool.ntp.org`` hangs
- ``mtr`` and ``traceroute`` show no relevant data

Diagnostic Steps
-----------------

1. Basic Network Interface Check
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   ip link show
   ip a

Expected:
- Interface should show ``state UP``
- Should have valid IP address

2. Routing Table Verification
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. code-block:: bash

   ip route

Expected:

- Default gateway route present (e.g., ``default via 192.168.1.1 dev eth0``)

3. DNS Resolution Test
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   nslookup google.com
   dig google.com

Fallback DNS Configuration:

.. code-block:: bash

   echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

4. Raw TCP Connection Test
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   nc -zv 8.8.8.8 80
   telnet 8.8.8.8 80

5. Firewall Inspection
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   sudo iptables -L
   sudo nft list ruleset

Temporary Firewall Disable:

.. code-block:: bash

   sudo iptables -F
   sudo nft flush ruleset

6. Network Service Restart
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   sudo systemctl restart NetworkManager
   # For headless servers:
   sudo systemctl restart networking # Debian/Ubuntu
   sudo systemctl restart network # RHEL/CentOS

7. Kernel-Level Network Debugging
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   sudo netstat -i
   sudo ethtool -S eth0
   sudo sysctl net.ipv4.icmp_echo_ignore_all

8. Advanced Diagnostics
~~~~~~~~~~~~~~~~~~~~~~~~~

Packet Capture:

.. code-block:: bash

   sudo tcpdump -i eth0 icmp

Strace Analysis:

.. code-block:: bash

   strace -o ping.log ping -c 1 8.8.8.8
   grep -E 'connect|sendto|poll' ping.log

Critical Findings
-------------------

From strace output:
.. code-block:: text

   connect(4, {sa_family=AF_INET, sin_port=htons(1025), sin_addr=inet_addr("8.8.8.8")}, 16) = 0
   sendto() = 64 # Packets sent successfully
   poll() = 0 (Timeout) # No replies received

Root Cause Analysis
---------------------

1. Outbound packets are being sent (sendto succeeds)
2. No inbound replies received (poll timeouts)
3. Possible causes:

   - Gateway not forwarding packets
   - ISP blocking ICMP
   - Middlebox filtering traffic

Recommended Solutions
-----------------------

1. Gateway Testing:

   - Ping from router's admin interface
   - Check router's WAN connection

2. Network Bypass Test:

.. code-block:: bash

   sudo ip route del default
   sudo ip route add default via <alternate_gateway> dev <interface>

3. ISP Verification:

   - Test with VPN connection
   - Contact ISP if gateway cannot ping 8.8.8.8

4. System Configuration:

.. code-block:: bash

   sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0

Additional Notes
------------------
- Time updates suggest intermittent NTP functionality
- Consider checking chrony/NTPD configuration
- For persistent issues, test with Live USB to isolate hardware problems
