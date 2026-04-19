# Laravel Tools

> **deploy** & **worker** — CLI utilities untuk Laravel deployment & Supervisor queue management di shared/VPS hosting.

**Author:** Donny Iskandarsyah  
**Credits:** ChatGPT (GPT-5) & Claude (Sonnet 4.6)

---

## ⚡ Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/donnebanget/laravel-tools/main/install.sh | bash
```

---

## 🛠️ Tools

### `deploy` — Laravel Smart Deploy

Jalankan dari root direktori Laravel project.

| Command | Keterangan |
|---|---|
| `deploy` | Quick optimization (no Git/NPM) |
| `deploy --init` | First-time full initialization |
| `deploy --update` | Git pull + rebuild assets |
| `deploy --help` | Show help |

**Apa yang dilakukan:**
- Install Composer dependencies (auto-detect production/dev)
- NPM install + build assets (hanya pada `--init` / `--update`)
- Clear & rebuild Laravel cache
- Auto-restart Supervisor worker (jika sudah di-setup)

---

### `worker` — Laravel Worker Manager

Manage Laravel queue workers via Supervisor. Jalankan sebagai **root** atau user dengan **sudo**.

| Command | Keterangan |
|---|---|
| `worker create [user] [domain?] [queue?]` | Buat worker baru |
| `worker remove [user] [--force]` | Hapus worker |
| `worker list` | List semua workers |
| `worker restart [user]` | Restart worker |
| `worker status [user?]` | Cek status worker |
| `worker logs [user] [out\|err]` | Tail log worker |

**Control panel yang didukung:**
- CloudPanel (`/home/user/htdocs`)
- FastPanel (`/var/www/user/data/www`)
- Plesk (`/var/www/vhosts/user/httpdocs`)
- cPanel (`/home/user/public_html`)
- Generic (`/var/www/user`)

---

## 📋 Typical Workflow

```bash
# 1. Setup worker (jalankan sekali sebagai root)
sudo worker create myuser example.com

# 2. Deploy pertama kali
cd /path/to/laravel
deploy --init

# 3. Update deployment berikutnya
deploy --update

# 4. Cek status worker
worker status myuser

# 5. Tail log worker
worker logs myuser out
```

---

## 🔐 Sudoers Auto-Setup

Saat `worker create` dijalankan, script otomatis membuat entry di `/etc/sudoers.d/` sehingga user dapat melakukan `restart` worker tanpa password. Ini memungkinkan `deploy` me-restart worker secara otomatis tanpa intervensi manual.

---

## 📁 Repository Structure

```
laravel-tools/
├── bin/
│   ├── deploy      # Laravel deploy script
│   └── worker      # Supervisor worker manager
├── install.sh      # One-line installer
└── README.md
```

---

## 🔄 Update Tools

Jalankan ulang installer untuk update ke versi terbaru:

```bash
curl -sSL https://raw.githubusercontent.com/donnebanget/laravel-tools/main/install.sh | bash
```
