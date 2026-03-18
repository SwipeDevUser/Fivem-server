# FiveM Server - Complete Network Setup Guide
## Your Configuration

**Your Local IP**: 192.168.1.11  
**Your Public IP**: 108.188.113.251  
**FiveM Port**: 30120 (TCP & UDP)  
**Server ID**: krb6e7  

---

## ⚡ Step 1: Identify Your Router

Your router gateway is: `fe80::a697:33ff:fee4:34f0%14` (IPv6) or typically `192.168.1.1` or `192.168.0.1`

**Common Router Login URLs:**
- TP-Link: http://192.168.0.1 or http://tplinkwifi.net
- Netgear: http://routerlogin.net or http://192.168.1.1
- Linksys: http://myrouter.local or http://192.168.1.1
- D-Link: http://192.168.1.1
- ASUS: http://router.asus.com or http://192.168.1.1

---

## 🔧 Step 2: Access Your Router

1. **Open your browser**
2. **Type**: http://192.168.1.1 (or http://192.168.0.1)
3. **Login** with your credentials (check router label if unsure)
4. **Look for**: 
   - Port Forwarding
   - Virtual Server
   - Port Mapping
   - NAT Settings

---

## 📍 Step 3: Add Port Forwarding Rules

You need to add TWO rules (TCP and UDP):

### FiveM Server TCP Port Forward
- **External Port**: 30120
- **Internal Port**: 30120
- **Internal IP**: 192.168.1.11
- **Protocol**: TCP
- **Enable**: Yes

### FiveM Server UDP Port Forward
- **External Port**: 30120
- **Internal Port**: 30120
- **Internal IP**: 192.168.1.11
- **Protocol**: UDP
- **Enable**: Yes

---

## ✅ Step 4: Verify Configuration

### Test Locally (Before Online Testing)
```
Open FiveM Client Console (F8):
connect 127.0.0.1:30120
```

### Test Online (After Router Setup)
```
Open FiveM Client Console (F8):
connect krb6e7.cfx.me
```

---

## 🔍 Troubleshooting

### Port Forwarding Not Working?

**Check these areas in your router:**

1. **UPnP/UPnP IGD** - Enable this if available (auto port forwarding)
2. **Firewall Settings** - Set to LOW/OPEN for port 30120
3. **DMZ** (Demilitarized Zone) - Alternative: Set to 192.168.1.11
4. **Port Range** - Ensure 30120 isn't blocked by router
5. **Reboot Router** - After adding rules, restart router

### Still Can't Connect?

Check these on your PC:
1. **Windows Firewall** - Port 30120 allowed ✓ (Already configured)
2. **3rd Party Firewall** - Disable temporarily to test
3. **ISP Blocking** - Some ISPs block ports (try 30121 instead)
4. **Server Running** - Check http://localhost:40120/ still shows server

---

## 🌐 Optional: DynDNS Setup

If your public IP changes, consider DynDNS:

1. Use service like: http://noip.com or http://duckdns.org
2. Get a free subdomain (easier than remembering IP)
3. Players can connect to your subdomain instead of IP

---

## 📊 Summary of Ports to Forward

| Service | Port | Protocol | Internal IP |
|---------|------|----------|------------|
| FiveM Server | 30120 | TCP | 192.168.1.11 |
| FiveM Server | 30120 | UDP | 192.168.1.11 |
| txAdmin (Optional) | 40120 | TCP | 192.168.1.11 |

---

## 🎮 Once Everything Works

**Players can connect using:**
- `connect krb6e7.cfx.me` (via FiveM server list)
- `connect 108.188.113.251:30120` (direct IP)
- `connect YOUR_DYNAMIC_DNS:30120` (if you set up DynDNS)

---

## 📞 Support Resources

- **FiveM Docs**: https://docs.fivem.net/
- **txAdmin Help**: https://github.com/tabarra/txAdmin
- **Server Verification**: https://server-info.fivem.net/
- **Port Test**: https://canyouseeme.org/ (test if port is open)

---

**Next Steps:**
1. ✓ Log into your router
2. ✓ Add port forwarding rules (2 rules above)
3. ✓ Save & restart router
4. ✓ Test connection
5. ✓ Share server link with friends!

Good luck! 🚀
