<div align="right">

[**🇹🇷 Türkçe (README.md)**](README.md) | [**🇬🇧 English (README_EN.md)**](README_EN.md)

</div>

# 🛡️ Win10-Stealth-RE-Lab: Tersine Mühendislik & Malware Analiz Laboratuvarı

![Platform](https://img.shields.io/badge/Platform-Windows%2010%20Pro%20x64-0078D6?style=for-the-badge&logo=windows)
![Hypervisor](https://img.shields.io/badge/Stealth-Anti--VM%20%26%20Pafish%20Verified-2ea44f?style=for-the-badge&logo=linux)
![Tools](https://img.shields.io/badge/RE%20Tools-35%2B%20Pre--Installed-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

**Win10-Stealth-RE-Lab**; Binary Analiz, Crackme/CTF Çözümü, Zararlı Yazılım (Malware) Analizi ve Android (`.apk`) / Java (`.jar`) / .NET (`C#`) Tersine Mühendisliği için sıfırdan yapılandırılmış, **Anti-VM / Anti-Debug (Stealth)** yamaları uygulanmış ve gereksiz tüm Windows servislerinden arındırılmış hazır bir sanal makine ve otomasyon projesidir.

---

## 📥 Hazır Sanal Makine İmajını İndir (Tak-Çalıştır `.vmdk`)

Hiçbir kurulumla uğraşmadan, tüm araçların ve sistem ayarlarının hazır olduğu **sıkıştırılmış sanal makine imajını (`Win10_RE_Lab.7z` - 14 GB)** aşağıdaki bağlantıdan doğrudan indirebilirsiniz:

<div align="center">

### 👉 [**📥 GOOGLE DRIVE ÜZERİNDEN İNDİR (Win10_RE_Lab.7z - 14 GB)**](https://drive.google.com/file/d/1kq87bzjmorSzWxC2d8lhuyFhXMI6f8ea/view?usp=sharing) 👈

</div>

> [!TIP]
> **İndirme Kotası İpucu:** Google Drive *"24 saatlik indirme kotası aşıldı"* uyarısı verirse, kendi Google hesabınızla giriş yapıp dosyaya sağ tıklayarak **Drive'ıma kısayol ekle -> Kopyasını oluştur** adımıyla beklemeden indirebilirsiniz.

---

## Sanal Makine Nasıl Kurulur / Açılır?

İndirdiğiniz **`Win10_RE_Lab.7z`** arşivini **7-Zip** veya **WinRAR** ile klasöre çıkarttığınızda içinden **`Win10_RE_Lab.vmdk`** sanal disk dosyası çıkacaktır:

1. **VMware Workstation / Player:**
   * `Create a New Virtual Machine` -> `I will install the operating system later` -> `Microsoft Windows 10 x64` seçin.
   * Disk adımında **`Use an existing virtual disk`** seçeneğini işaretleyip **`Win10_RE_Lab.vmdk`** dosyasını gösterin.
   * `Customize Hardware` -> `Options` -> `Advanced` kısmından Firmware olarak **UEFI** seçip başlatın.
2. **Oracle VirtualBox:**
   * `Yeni (New)` -> İsim: `Win10_RE_Lab`, Tür: `Microsoft Windows 10 (64-bit)` seçin.
   * **`Önyükleme için EFI'yi etkinleştir (Enable EFI)`** kutucuğunu işaretleyin.
   * Sabit Disk adımında **`Mevcut bir sanal sabit disk dosyası kullan`** diyerek **`Win10_RE_Lab.vmdk`** dosyasını seçip başlatın.
3. **Linux KVM / QEMU (Virt-Manager):**
   * `Yeni Sanal Makine` -> **`Mevcut disk görüntüsünü içe aktar (Import existing disk image)`** seçin.
   * Disk olarak `Win10_RE_Lab.vmdk` seçin (veya `qemu-img convert -O qcow2 Win10_RE_Lab.vmdk Win10_RE_Lab.qcow2` ile `.qcow2`'ye çevirin).
   * Tam **Anti-VM Stealth** performansı için bu depodaki [`kvm/win10_stealth_lab.xml`](kvm/win10_stealth_lab.xml) yapılandırmasını kullanabilirsiniz.

---

## İçerisinde Hazır Kurulu Araçlar (6 Kategori)

Masaüstündeki **`RE_Tools`** (ve `C:\RE_Tools`) klasöründe tüm araçlar kategorilerine göre hazır dizilmiştir:

| Kategori | Kurulu Araçlar | Açıklama |
| :--- | :--- | :--- |
| **1. Disassembler & Decompiler** | **Ghidra 12.2** (+ JDK 21), **IDA Pro**, **Cutter (Rizin)**, **dnSpyEx (64-bit)** | Native (`x86`/`x64`/`ARM`) ve `.NET (C#)` ikili dosyaları kaynak koduna dönüştürme ve statik analiz. |
| **2. Debugger (Dinamik Analiz)** | **x64dbg**, **x32dbg** + **ScyllaHide** *(Ön tanımlı entegre!)* | 32/64-bit dinamik hata ayıklama. **ScyllaHide** eklentisi otomatik kuruludur, Anti-Debug kontrollerini tek tıkla atlatır. |
| **3. APK & Java Reverse** | **JADX-GUI**, **APK Studio**, **APKTool**, **Bytecode Viewer**, **JD-GUI**, **Recaf**, **Android Studio (AVD)**, **BlueStacks**, **ADB**, **Frida & Objection** | Android `.apk`, `.dex` ve Java `.jar`/`.class` dosyalarını decompile etme, Smali düzenleme, yeniden imzalama ve SSL Pinning bypass. |
| **4. PE, Packer & Hex Analizi** | **Detect It Easy (DIE)**, **PE-bear**, **CFF Explorer**, **ImHex**, **HxD**, **Resource Hacker**, **FLOSS**, **CAPA**, **UPX** | Dosya imzası/packer tespiti, PE başlık düzenleme, veri yapısı destekli Hex analizi ve şifreli string/yetenek çıkarımı. |
| **5. Sistem, Ağ & Kripto** | **CyberChef (Offline)**, **Everything**, **System Informer**, **Process Monitor (Procmon)**, **Process Explorer**, **Autoruns**, **TCPView**, **VMMap**, **Wireshark**, **MITMProxy** | Sistem çağrılarını, kayıt defteri ve dosya hareketlerini, bellek haritasını ve ağ/HTTPS trafiğini canlı izleme. |
| **6. Unpacker, Dumper & Pro Araçlar** | **HollowsHunter**, **PE-sieve**, **de4dot-cex**, **ExtremeDumper**, **API Monitor v2**, **FakeNet-NG**, **Regshot**, **UniExtract2**, **InnoExtract**, **PyInstxtractor**, **Pafish** | Bellekte çalışan şifreli/packed zararlıları RAM'den otomatik dump etme, `.NET`/ConfuserEx şifre çözme, canlı API yakalama ve sahte internet simülasyonu. |

---

## Özel Sağ Tık Menüsü (Context Menu) Entegrasyonu

Herhangi bir `.exe`, `.dll` veya `.apk` dosyasına **Sağ Tıkladığınızda** doğrudan şu analiz seçenekleri çıkar:

* 🔹 **`1. Detect It Easy (DIE) ile Analiz Et`**
* 🔹 **`2. PE-bear ile İncele`**
* 🔹 **`3. x64dbg (64-bit) ile Debug Et`**
* 🔹 **`4. x32dbg (32-bit) ile Debug Et`**
* 🔹 **`5. ImHex ile Hex İncele`**
* 🔹 **`6. JADX-GUI ile Aç (APK/JAR)`**
* 🔹 **`7. de4dot ile .NET Şifresini Çöz (Deobfuscate)`**

Ayrıca terminalde (`CMD` / `PowerShell`) her klasörden doğrudan şu komutları çalıştırabilirsiniz:
```powershell
floss hedef.exe             # Gizlenmiş/obfuscated string'leri otomatik çözer
capa hedef.exe              # Dosyanın yeteneklerini (anti-debug, keylogger, C2 vb.) raporlar
hollows_hunter64 /pname x   # Çalışan şifreli işlemi RAM'den unpack edip diske kaydeder
apktool d uygulama.apk      # APK dosyasını kaynaklarına ve Smali kodlarına ayıklar
```

---

## Anti-VM Stealth & İşletim Sistemi Sertleştirmesi (OPSEC)

Bu laboratuvar, incelenen zararlı yazılımların sanal makineyi tespit etmesini önlemek ve analist güvenliğini sağlamak için özel olarak yapılandırılmıştır:

* **Anti-VM Gizliliği (Pafish Verified `[OK]`):**
  * Disk kimliği, Anakart/BIOS ve CPU Hypervisor imzaları gizlenmiştir.
  * Her açılışta çalışan `AntiVM_Stealth` görevi ile `HKLM\HARDWARE\DEVICEMAP\Scsi` ve `SystemBiosVersion` kayıtları otomatik temizlenir.
* **Sıfır Bulut Sızıntısı & Maksimum Performans:**
  * **Windows Defender**, **SmartScreen**, **Buluta Örnek Gönderimi (`SubmitSamplesConsent = NeverSend`)**, **Windows Hata Raporlama (`WerFault.exe`)** ve **Telemetri** kalıcı olarak kapatılmıştır.
  * **Windows Update** (`WaaSMedicSvc` ve `UsoSvc` dahil) tamamen kilitlenmiştir; analiz ortasında asla güncelleme yapmaz.
  * **Copilot**, **Microsoft Edge**, **Microsoft Store**, **Bing Web Araması** ve **Hava Durumu** bloatware paketleri sistemden tamamen kaldırılmış, yerine temiz **Mozilla Firefox** kurulmuştur.
  * **Microsoft Sembol Sunucusu (`_NT_SYMBOL_PATH`)** sistem genelinde `C:\Symbols` önbelleğiyle tanımlanmıştır.

---

## Kendi Windows 10 Sanal Makinenizde Scriptleri Çalıştırma

Hazır imajı indirmek yerine kendi kurduğunuz temiz bir Windows 10 sanal makinesini bu laboratuvara dönüştürmek isterseniz, [`scripts/`](scripts/) klasöründeki otomasyon dosyalarını **Yönetici (Administrator)** olarak sırasıyla çalıştırmanız yeterlidir:

1. [`scripts/Mega_RE_Kur.bat`](scripts/Mega_RE_Kur.bat) -> Temel ve orta seviye RE araçlarını kurar ve kategorize eder.
2. [`scripts/Ileri_Seviye_RE_Kur.bat`](scripts/Ileri_Seviye_RE_Kur.bat) -> Unpacker, Dumper, ScyllaHide ve Pro araçları kurar.
3. [`scripts/RE_Sistem_Ayarlari.bat`](scripts/RE_Sistem_Ayarlari.bat) -> Sağ tık menüsünü, Defender/SmartScreen kapatmayı ve analiz görünümünü ayarlar.
4. [`scripts/Bloatware_ve_Update_Sil.bat`](scripts/Bloatware_ve_Update_Sil.bat) -> Edge, Copilot, Store, Bing ve Windows Update'i sistemden kaldırır.
5. [`scripts/Pafish_Gizlilik_Yamasi.bat`](scripts/Pafish_Gizlilik_Yamasi.bat) -> Anti-VM Kayıt Defteri gizlilik görevini kurar.

---

## ⚠️ Analiz Öncesi 2 Altın Güvenlik Kuralı

1. **Snapshot Alın:** Gerçek bir zararlı yazılım (Malware / Ransomware / Stealer) çalıştırmadan önce mutlaka temiz bir **Snapshot (Anlık Görüntü)** alın.
2. **Ağı İzole Edin:** Zararlı yazılım incelerken sanal makinenin internet bağlantısını kesin (veya *Host-Only / Isolated Network* moduna alın) ve içeride **`FakeNet-NG`** aracını başlatın.
