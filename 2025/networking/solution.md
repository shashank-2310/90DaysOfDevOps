## Week 1 Networking Notes

### 1. OSI and TCP/IP Models in Practice
- Physical: fiber or copper cabling, Wi-Fi radio signals carrying frames.
- Data Link: Ethernet framing and MAC filtering on a switch; VLAN tagging to segment traffic.
- Network: IP routing between subnets; routers applying CIDR rules and forwarding packets.
- Transport: TCP for reliable web requests (SYN/ACK, retransmits), UDP for low-latency DNS or streaming.
- Session: TLS session resumption or a database connection pool maintaining stateful sessions.
- Presentation: TLS encryption/decryption, JSON or protobuf serialization for APIs.
- Application: HTTP/HTTPS for web apps, SSH for remote admin, SMTP for mail relay.

TCP/IP view (4-layer):
- Link: Ethernet/Wi-Fi frames on the local network.
- Internet: IPv4/IPv6 routing across networks.
- Transport: TCP vs. UDP depending on reliability/latency needs.
- Application: Protocol payloads such as HTTP, DNS, SSH, MQTT.

### 2. Protocols and Ports for DevOps
| Protocol | Default Port(s) | Why it matters |
| --- | --- | --- |
| HTTP | 80 | Health checks, simple services, load balancer targets.
| HTTPS | 443 | Secure web traffic; API endpoints and ingress controllers.
| SSH | 22 | Secure remote admin, Git over SSH, tunneling.
| DNS | 53 (UDP/TCP) | Name resolution for services and clusters.
| FTP / FTPS | 21 / 990 | Legacy file transfer; minimize or lock down.
| SFTP | 22 | Secure file transfer via SSH; common for batch jobs.
| SMTP | 25, 587 | Outbound mail relays, alerting.
| IMAP/POP3 | 143/993, 110/995 | Mail retrieval (avoid on prod hosts unless needed).
| RDP | 3389 | Windows administration; restrict by source IP and MFA.
| MySQL | 3306 | Database access; keep private, use SG/ACLs/SSL.
| PostgreSQL | 5432 | Same as above; restrict and encrypt.
| Redis | 6379 | Caches/queues; require auth/TLS, private only.
| MongoDB | 27017 | Datastores; bind locally or to private subnets.

### 3. AWS Security Groups (SG) Guide
1) Create an SG: VPC console → Security Groups → Create → name + description + VPC.
2) Inbound rules: add only required ports; prefer My IP for SSH/RDP; use custom TCP/UDP ranges for app ports.
3) Outbound rules: default allow all is common; tighten to required CIDRs/services for stricter egress.
4) Attach SG: assign to EC2 at launch or via Actions → Security → Change security groups.
5) Test: from an allowed source, verify `ssh` or `curl`; from a blocked source, confirm denial.
6) Best practices: least privilege, avoid 0.0.0.0/0 on SSH/RDP, reuse SG references (e.g., app SG allows traffic from ALB SG), enable VPC Flow Logs for auditing, rotate temporary openings.

### 4. Networking Commands Cheat Sheet
- ping: reachability and latency.
	- Linux: `ping -c 4 example.com`
	- Windows: `ping -n 4 example.com`
- traceroute / tracert: path hops.
	- Linux: `traceroute example.com`
	- Windows: `tracert example.com`
- netstat (or ss): sockets and listeners.
	- Linux: `ss -tulpn | head` or `netstat -tulpn`
	- Windows: `netstat -ano | findstr LISTEN`
- curl: HTTP requests and debugging.
	- `curl -i https://example.com` (headers)
	- `curl -v https://example.com` (verbose handshake)
- dig / nslookup: DNS lookups.
	- Linux: `dig A example.com +short` or `dig @1.1.1.1 example.com ANY`
	- Windows: `nslookup example.com 1.1.1.1`

Quick usage tips:
- Add `-6` flags to test IPv6 where supported.
- Combine `curl` with `--resolve` to test DNS overrides: `curl --resolve example.com:443:1.2.3.4 https://example.com`.
- Use `ping`/`traceroute` with IP and hostname to spot DNS vs. routing issues.
- Pair `netstat/ss` with process IDs to find which service owns a port.
