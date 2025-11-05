Network Debugging Guide
==========================

Initial Issue
--------------

- User reported ``ping pool.ntp.org`` freezing the console.
- Subsequent tests (``ping 8.8.8.8``, ``curl``, ``mtr``) showed either freezes or incomplete data.

Diagnostic Steps
------------------

1. Basic Connectivity Checks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Check interface status
   ip link show
   ip a

   # Test raw connectivity
   nc -zv 8.8.8.8 80
   arping -I eth0 192.168.1.1

2. Routing and DNS
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Verify routing table
   ip route

   # Test DNS resolution
   nslookup google.com
   dig google.com

3. Firewall Inspection
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Check iptables
   sudo iptables -L

   # Check nftables
   sudo nft list ruleset

4. Advanced Diagnostics
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Kernel network stats
   sudo netstat -i
   sudo ethtool -S eth0

   # Strace analysis
   strace ping -c 1 8.8.8.8

Key Findings
--------------

1. Network Stack Behavior:

   - ``sendto()`` calls succeeded (outbound packets sent)
   - ``poll()`` timed out (no replies received)
   - ARP working (gateway reachable at L2)

2. Identified Issues:

   - Outbound packets not being routed back
   - Possible causes:
     * Gateway misconfiguration
     * ISP blocking
     * NAT/firewall interference

Solutions Applied
-------------------

1. Gateway Testing:

   - Recommended testing router's WAN connectivity
   - Suggested bypassing gateway via hotspot

2. ISP Verification:

   - Recommended VPN test to bypass potential ISP blocking

3. Kernel Parameters:

   - Checked ICMP echo settings::

       sudo sysctl net.ipv4.icmp_echo_ignore_all

4. Alternative Networks:

   - Suggested testing with different network interfaces

Final Recommendations
-----------------------

1. Conclusive Tests:

   - Use mobile hotspot to isolate gateway issues
   - Test with VPN to check for ISP blocking

2. Administrative Actions:

   - Contact ISP if gateway cannot ping 8.8.8.8
   - Check router logs for dropped packets

3. Persistent Configuration:

   - For DNS issues::

       echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

   - For routing issues::

       sudo ip route add default via <gateway_ip> dev <interface>
