<div align="right">

[**🇹🇷 Türkçe (README.md)**](README.md) | [**🇬🇧 English (README_EN.md)**](README_EN.md)

</div>

# 🛡️ Win10-Stealth-RE-Lab: Reverse Engineering & Malware Analysis Lab

![Platform](https://img.shields.io/badge/Platform-Windows%2010%20Pro%20x64-0078D6?style=for-the-badge&logo=windows)
![Hypervisor](https://img.shields.io/badge/Stealth-Anti--VM%20%26%20Pafish%20Verified-2ea44f?style=for-the-badge&logo=linux)
![Tools](https://img.shields.io/badge/RE%20Tools-35%2B%20Pre--Installed-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

**Win10-Stealth-RE-Lab** is a ready-to-use, fully hardened Windows 10 Reverse Engineering & Malware Analysis virtual machine image and automation suite. Built from the ground up for **Binary Analysis, Crackme/CTF Solving, Malware Analysis, and Android (`.apk`) / Java (`.jar`) / .NET (`C#`) Reverse Engineering**, it comes pre-patched with **Anti-VM / Anti-Debug (Stealth)** mitigations and is completely stripped of Windows telemetry, bloatware, and automatic updates.

---

## 📥 Download Ready-to-Use Virtual Machine Image (Plug & Play `.vmdk`)

Skip hours of installation and configuration! You can download the pre-configured, ultra-compressed virtual machine image (**`Win10_RE_Lab.7z` - 14 GB**) directly from Google Drive:

<div align="center">

### 👉 [**📥 DOWNLOAD FROM GOOGLE DRIVE (Win10_RE_Lab.7z - 14 GB)**](https://drive.google.com/file/d/1kq87bzjmorSzWxC2d8lhuyFhXMI6f8ea/view?usp=sharing) 👈

</div>

> [!TIP]
> **Google Drive Quota Tip:** If Google Drive displays a *"Download quota exceeded for this file"* message, simply sign in to your Google account, right-click the file in Drive, and select **Add shortcut to Drive -> Make a copy** to download it immediately without restrictions.

---

## How to Import & Run the Virtual Machine

Extract **`Win10_RE_Lab.7z`** using **7-Zip** or **WinRAR** to obtain the **`Win10_RE_Lab.vmdk`** virtual disk image:

1. **VMware Workstation / Player:**
   * Select `Create a New Virtual Machine` -> `I will install the operating system later` -> `Microsoft Windows 10 x64`.
   * On the Disk step, select **`Use an existing virtual disk`** and browse to **`Win10_RE_Lab.vmdk`**.
   * Go to `Customize Hardware` -> `Options` -> `Advanced` and set Firmware type to **UEFI**, then boot the VM.
2. **Oracle VirtualBox:**
   * Click `New` -> Name: `Win10_RE_Lab`, Type: `Microsoft Windows 10 (64-bit)`.
   * Check **`Enable EFI (special OSes only)`** under Hardware/System settings.
   * On the Hard Disk step, choose **`Use an existing virtual hard disk file`**, select **`Win10_RE_Lab.vmdk`**, and start the VM.
3. **Linux KVM / QEMU (Virt-Manager):**
   * Click `Create a new virtual machine` -> **`Import existing disk image`**.
   * Select `Win10_RE_Lab.vmdk` (or convert it to `qcow2` via `qemu-img convert -O qcow2 Win10_RE_Lab.vmdk Win10_RE_Lab.qcow2`).
   * For full **Anti-VM Stealth** spoofing on KVM, use the included [`kvm/win10_stealth_lab.xml`](kvm/win10_stealth_lab.xml) domain configuration.

---

## Pre-Installed Reverse Engineering Arsenal (6 Categories)

All tools are neatly organized into 6 categorized folders inside **`Desktop\RE_Tools`** (and `C:\RE_Tools`):

| Category | Pre-Installed Tools | Purpose |
| :--- | :--- | :--- |
| **1. Disassemblers & Decompilers** | **Ghidra 12.2** (+ JDK 21), **IDA Pro**, **Cutter (Rizin)**, **dnSpyEx (64-bit)** | Static analysis and decompilation of native (`x86`/`x64`/`ARM`) and `.NET (C#)` binaries. |
| **2. Debuggers (Dynamic Analysis)** | **x64dbg**, **x32dbg** + **ScyllaHide** *(Pre-integrated!)* | 32/64-bit user-mode debugging. **ScyllaHide** is pre-installed into the plugin directory to bypass Anti-Debug checks out of the box. |
| **3. APK & Java Reversing** | **JADX-GUI**, **APK Studio**, **APKTool**, **Bytecode Viewer**, **JD-GUI**, **Recaf**, **Android Studio (AVD)**, **BlueStacks**, **ADB**, **Frida & Objection** | Decompile Android `.apk`/`.dex` and Java `.jar`/`.class` files, edit Smali/bytecode, re-sign packages, and bypass SSL Pinning / Root detection. |
| **4. PE, Packer & Hex Analysis** | **Detect It Easy (DIE)**, **PE-bear**, **CFF Explorer**, **ImHex**, **HxD**, **Resource Hacker**, **FLOSS**, **CAPA**, **UPX** | Compiler/packer identification, PE header manipulation, structure-aware hex editing, and automated obfuscated string/capability extraction. |
| **5. System, Network & Crypto** | **CyberChef (Offline)**, **Everything**, **System Informer**, **Process Monitor (Procmon)**, **Process Explorer**, **Autoruns**, **TCPView**, **VMMap**, **Wireshark**, **MITMProxy** | Real-time process, thread, registry, filesystem, memory map, and network/HTTPS traffic monitoring & decoding. |
| **6. Unpackers, Dumpers & Pro Tools** | **HollowsHunter**, **PE-sieve**, **de4dot-cex**, **ExtremeDumper**, **API Monitor v2**, **FakeNet-NG**, **Regshot**, **UniExtract2**, **InnoExtract**, **PyInstxtractor**, **Pafish** | Automated in-memory unpacking/dumping of hollowed or packed processes, `.NET`/ConfuserEx deobfuscation, live Win32 API hooking, and C2 network simulation. |

---

## Custom Right-Click Context Menu Integration

Right-clicking any `.exe`, `.dll`, or `.apk` file in Windows Explorer provides instant one-click access to:

* 🔹 **`1. Analyze with Detect It Easy (DIE)`**
* 🔹 **`2. Inspect with PE-bear`**
* 🔹 **`3. Debug with x64dbg (64-bit)`**
* 🔹 **`4. Debug with x32dbg (32-bit)`**
* 🔹 **`5. Hex Inspect with ImHex`**
* 🔹 **`6. Open with JADX-GUI (APK/JAR)`**
* 🔹 **`7. Deobfuscate .NET Assembly with de4dot`**

Additionally, key CLI tools are pre-configured in the global system `PATH`:
```powershell
floss target.exe            # Automatically extract obfuscated & stack strings
capa target.exe             # Detect binary capabilities (anti-debug, keylogger, C2, crypto)
hollows_hunter64 /pname x   # Scan & dump unpacked/injected PE payloads directly from RAM
apktool d app.apk           # Decode APK resources and Smali source code
```

---

## Anti-VM Stealth & OS Hardening (OPSEC)

This lab is specifically hardened to evade anti-analysis checks and prevent unintended cloud sample leakage:

* **Anti-VM Stealth (Pafish Verified `[OK]`):**
  * Hardware identifiers are spoofed to mimic a physical machine (**Disk:** `Samsung SSD 990 PRO 1TB`, **Motherboard/BIOS:** `ASUS ROG STRIX Z790-E / American Megatrends 3205`, **CPU:** Hypervisor bit disabled).
  * An automated logon task (`AntiVM_Stealth`) sanitizes volatile `HKLM\HARDWARE\DEVICEMAP\Scsi` and `SystemBiosVersion` registry keys on every boot.
* **Zero Cloud Leakage & Maximum Stability:**
  * **Windows Defender**, **SmartScreen**, **Cloud Sample Submission (`SubmitSamplesConsent = NeverSend`)**, **Windows Error Reporting (`WerFault.exe`)**, and **Telemetry** are permanently disabled via Group Policy and Registry locks.
  * **Windows Update** (including `WaaSMedicSvc` and `UsoSvc`) is completely locked down to prevent unexpected reboots or security resets.
  * **Copilot**, **Microsoft Edge**, **Microsoft Store**, **Bing Search**, and **Weather** bloatware packages have been completely removed and replaced with a clean **Mozilla Firefox** installation.
  * **Microsoft Symbol Server (`_NT_SYMBOL_PATH`)** is pre-configured system-wide (`srv*C:\Symbols*https://msdl.microsoft.com/download/symbols`).

---

## Building the Lab Yourself via Automation Scripts

If you prefer to build the lab on your own clean Windows 10 VM instead of downloading the pre-built image, run the scripts inside [`scripts/`](scripts/) as **Administrator** in the following order:

1. [`scripts/Mega_RE_Kur.bat`](scripts/Mega_RE_Kur.bat) -> Installs and categorizes core and intermediate RE tools.
2. [`scripts/Ileri_Seviye_RE_Kur.bat`](scripts/Ileri_Seviye_RE_Kur.bat) -> Installs unpackers, dumpers, ScyllaHide, and pro tools.
3. [`scripts/RE_Sistem_Ayarlari.bat`](scripts/RE_Sistem_Ayarlari.bat) -> Configures right-click menus, Explorer view settings, and disables Defender/SmartScreen/WerFault.
4. [`scripts/Bloatware_ve_Update_Sil.bat`](scripts/Bloatware_ve_Update_Sil.bat) -> Removes Edge, Copilot, Store, Bing, and permanently locks Windows Update.
5. [`scripts/Pafish_Gizlilik_Yamasi.bat`](scripts/Pafish_Gizlilik_Yamasi.bat) -> Installs the persistent Anti-VM Registry stealth task.

---

## ⚠️ 2 Golden Safety Rules Before Analyzing Malware

1. **Take a Snapshot:** Always create a clean VM **Snapshot** before executing untrusted binaries or live malware samples.
2. **Isolate the Network:** Disconnect the virtual network adapter (or switch to an *Isolated / Host-Only Network*) and run **`FakeNet-NG`** inside the VM when analyzing real malware.
