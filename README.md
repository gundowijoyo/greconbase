# 🚀 GreconBase

**GreconBase** adalah sebuah *Monolithic Stealth Reconnaissance Framework* berbasis Bash yang dirancang khusus untuk melakukan audit keamanan eksternal (*External Security Auditing*) dan pemetaan jejak digital (*Passive Footprinting*) pada sebuah server web berbasis domain.

Tool ini dibangun secara ringkas dalam satu file tunggal (*all-in-one script*) dengan fokus pada **Evasion & Stealth** agar proses audit berjalan dengan cara meniru perilaku manusia, meminimalkan risiko terblokir oleh Firewall, serta menghindari deteksi bot otomatis.

---

## 🛡️ Tujuan Proyek & Edukasi (*Educational Purpose*)

Proyek ini bersifat **Open-Source** dan dibuat **murni untuk tujuan edukasi, pembelajaran, serta penelitian di bidang Cybersecurity** (*Defensive Security & Security Auditing*). 

Melalui proyek ini, diharapkan para pelajar, developer, dan praktisi keamanan pemula dapat memahami:
1. Bagaimana informasi server dapat bocor melalui konfigurasi HTTP header yang kurang tepat.
2. Pentingnya mengamankan berkas sensitif (`.env`, `.git`, dll.) agar tidak dapat diakses publik.
3. Cara kerja Web Application Firewall (WAF) dalam mendeteksi dan mengkategorikan *request* otomatis.
4. Cara menulis skrip otomasi Bash yang modular, bersih, dan aman.

---

## ⚖️ Penyangkalan & Pernyataan Hukum (*Disclaimer*)

> ⚠️ **PENTING:** 
> **Saya selaku pembuat/pengembang tool GreconBase TIDAK BERTANGGUNG JAWAB atas segala bentuk penyalahgunaan, kerusakan, kerugian, atau implikasi hukum yang disebabkan oleh alat ini.** 
> 
> Pengguna bertanggung jawab penuh atas tindakan mereka sendiri. Pastikan Anda hanya menggunakan tool ini pada domain milik Anda sendiri, atau pada target yang telah memberikan izin tertulis secara sah (*Authorized Security Testing*). Menguji sistem orang lain tanpa izin adalah tindakan ilegal dan melanggar hukum.

---

## ✨ Fitur Utama

- **All-in-One Framework:** Seluruh fungsionalitas berjalan dalam satu berkas skrip tunggal yang portabel tanpa *dependencies* rumit.
- **Stealth Evasion Engine:** Fitur rotasi *User-Agent* peramban populer secara acak, manipulasi header (`X-Forwarded-For`), dan jeda waktu dinamis (*random delay*) untuk meminimalkan *rate-limiting*.
- **WAF Identification:** Mendeteksi secara pasif jenis *Firewall* yang melindungi target (Cloudflare, Sucuri, AWS WAF, dll.).
- **Server Footprint Mapping:** Memetakan versi *Web Server Engine*, teknologi *backend*, serta resolusi IP Publik.
- **Low-Profile Sensitive File Fuzzing:** Memeriksa keberadaan file kritis terbuka (`.env`, `.git/config`, `robots.txt`, dll.) menggunakan metode HTTP HEAD request yang sangat ringan.
- **Markdown Report Generator:** Otomatis merangkum seluruh hasil audit ke dalam berkas laporan berformat `.md` yang rapi di folder `reports/`.

---

## 🛠️ Cara Instalan & Penggunaan

### 1. Kloning Repositori
```bash
git clone https://github.com/gundowijoyo/greconbase.git
cd greconbase
```

### 2. Berikan Izin Eksekusi Skrip
```bash
chmod +x greconbase.sh
```

### 3. Jalankan Pengujian
Untuk menjalankan audit standar secara langsung:
```bash
./greconbase.sh target.com
```

Untuk mengaktifkan fitur anti-deteksi bot dan proteksi pemblokiran WAF, gunakan *flag* `--stealth`:
```bash
./greconbase.sh target.com --stealth
```

---

## 📊 Contoh Output Laporan (`.md`)

Setiap pengujian yang selesai akan menghasilkan ringkasan eksekutif di dalam folder `reports/target.com_recon.md` dengan format sebagai berikut:

```markdown
# 📊 GreconBase Security Report - target.com
*Dibuat pada: Mon Oct  5 01:38:00 WIB 2026*

## 🛡️ Firewall & Evasion Status
- **WAF Detected:** Cloudflare 🛡️
- **Stealth Scan Engaged:** true

## 🔍 Server Footprint
- **Web Server:** nginx
- **Backend Infrastructure:** Tidak Dibocorkan (Aman)
- **Resolved IP:** 93.184.216.34
```

---

## 🤝 Berkontribusi

Kontribusi dari komunitas sangat terbuka luas! Jika Anda menemukan kutu (*bug*), ingin mengoptimalkan logika pemindaian, atau menambahkan modul baru (seperti modul pemeriksaan DNSSEC/Subdomain), silakan lakukan *Fork* repositori ini dan kirimkan *Pull Request* Anda.

---
**GreconBase** — *Membangun kesadaran keamanan siber yang lebih baik, selangkah demi selangkah.*
