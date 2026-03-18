# 🎮 FiveM Admin Dashboard - Complete Setup Checklist

## ✅ Phase 1: Installation (COMPLETE)

- [x] FiveM server extracted
- [x] License key added: `cfxk_eErpbH2fz1jqWuCAwCKg_1Ir5Ee`
- [x] Server ID: `krb6e7`
- [x] Resources created (dashboard, core, scripts)
- [x] Admin dashboard deployed on port 3000
- [x] Server endpoints configured in server.cfg
- [x] Windows Firewall opened for port 30120

---

## 🔧 Phase 2: Local Testing (DO THIS FIRST)

**Prerequisites:**
- FiveM client installed? ☐ Yes / ☐ No
- GTA V installed? ☐ Yes / ☐ No

**Test steps:**
1. [ ] FXServer running (check `http://localhost:40120/`)
2. [ ] Dashboard running (check `http://localhost:3000/`)
3. [ ] Open FiveM client
4. [ ] Press F8 to open console
5. [ ] Type: `connect 127.0.0.1:30120`
6. [ ] Verify you can join server
7. [ ] Check admin dashboard shows you as online

**Expected Result:** You're in-game and visible in dashboard

---

## 🌐 Phase 3: Router Setup (REQUIRED FOR ONLINE)

**Your Network Details:**
- Local IP: `192.168.1.11`
- Public IP: `108.188.113.251`
- FiveM Port: `30120`
- Protocol: TCP & UDP

**Setup Steps:**

1. [ ] Access router admin panel:
   - URL: `http://192.168.1.1` or `http://192.168.0.1`
   - Login: (check your router)

2. [ ] Find Port Forwarding settings in router menu:
   - Look for: "Port Forwarding", "Port Mapping", or "Virtual Server"

3. [ ] Add Rule #1 (TCP):
   - External Port: `30120`
   - Internal Port: `30120`
   - Internal IP: `192.168.1.11`
   - Protocol: `TCP`
   - Status: `Enable` ✓

4. [ ] Add Rule #2 (UDP):
   - External Port: `30120`
   - Internal Port: `30120`
   - Internal IP: `192.168.1.11`
   - Protocol: `UDP`
   - Status: `Enable` ✓

5. [ ] Save all changes
6. [ ] Reboot router (optional but recommended)
7. [ ] Wait 2-3 minutes for changes to apply

---

## 🔐 Phase 4: Security (OPTIONAL)

Optional security enhancements:

- [ ] Change txAdmin PIN from `3846`
- [ ] Set admin account password in txAdmin
- [ ] Configure server whitelist
- [ ] Review firewall rules
- [ ] Enable server logging

---

## 🧪 Phase 5: Verification

**Test local connection (before port forwarding):**
```
FiveM Console (F8):
connect 127.0.0.1:30120
```
Expected: ✓ Connects successfully

**Test LAN connection (on same network):**
```
From another PC on same WiFi/net:
connect 192.168.1.11:30120
```
Expected: ✓ Connects successfully

**Test port forwarding online (after router setup):**
```
FiveM Console (F8):
connect krb6e7.cfx.me
OR
connect 108.188.113.251:30120
```
Expected: ✓ Can see server in server list

**Test external port:**
Visit: https://canyouseeme.org/
- Enter port: `30120`
- Result: Should show "Success" or "open"

---

## 🛠️ Troubleshooting

### Issue: Can't Connect Locally
**Solution:**
1. Check FXServer is running: `http://localhost:40120/`
2. Run `test-port.bat` to verify port is listening
3. Restart FXServer

### Issue: Port Forwarding Not Working
**Solution:**
1. Verify both TCP & UDP rules added
2. Check internal IP is correct: `192.168.1.11`
3. Reboot router
4. Check ISP not blocking port 30120
5. Try UPnP if available in router

### Issue: Server Shows in List but Can't Join
**Solution:**
1. Check server max players not full
2. Check whitelist isn't enabled
3. Restart server from txAdmin
4. Clear FiveM cache: Delete `AppData\Local\FiveM\data`

### Issue: Dashboard Shows No Players
**Solution:**
1. Dashboard uses mock data by default
2. Check resources are loading (`status` in console)
3. Verify dashboard running: `http://localhost:3000/`

---

## 📊 Useful Commands

**In FXServer Console:**
```
status                    # List all resources
restart dashboard         # Restart dashboard resource
ensure scripts            # Load scripts resource
stop <resource>          # Stop a resource
```

**In Game (F8):**
```
connect 127.0.0.1:30120  # Local test
connect 192.168.1.11:30120  # LAN test
connect krb6e7.cfx.me     # Online (after port forwarding)
```

---

## 📱 Access Points

Once everything is working:

| Service | URL/Address | Purpose |
|---------|-------------|---------|
| Dashboard | `http://localhost:3000/` | Admin panel (local only) |
| txAdmin | `http://localhost:40120/` | Server management |
| Game Server | `connect krb6e7.cfx.me` | Join server in FiveM |
| Server Info | `http://YOUR_PUBLIC_IP:40120/` | Server status (online) |

---

## 🎉 Success Indicators

You'll know everything is working when:

✅ FiveM Dashboard loads without errors  
✅ You can join server from FiveM client  
✅ Dashboard shows you as online player  
✅ Admin panel accessible at `localhost:40120`  
✅ Friends can join using `krb6e7.cfx.me`  
✅ Server shows in FiveM server list  

---

## 📚 Next Steps After Setup

1. Configure custom resources in `/resources/`
2. Add admin/moderators in txAdmin
3. Set up server rules and whitelist
4. Configure job scripts and economy
5. Add police, EMS, and other jobsa
6. Set up Discord integration
7. Configure anti-cheat and security

---

## 🆘 Need Help?

**Resources:**
- FiveM Docs: https://docs.fivem.net/
- txAdmin GitHub: https://github.com/tabarra/txAdmin
- Server Listing: https://server-info.fivem.net/
- Community Forums: https://forum.cfx.re/

---

**Setup Date:** March 18, 2026  
**Server ID:** krb6e7  
**Status:** Ready for initial configuration
