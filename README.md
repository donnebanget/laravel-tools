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
| `deploy --update` | Safe Git pull + rebuild assets |
| `deploy --update --force` | Force Git sync (`reset --hard` + clean) |
| `deploy --update --force --yes` | Force Git sync tanpa prompt konfirmasi |
| `deploy --no-migrate` | Skip migrations |
| `deploy --no-maintenance` | Disable maintenance mode |
| `deploy --pm=pnpm` | Pakai package manager tertentu (`auto`, `npm`, `pnpm`, `yarn`, `bun`) |
| `deploy --help` | Show help |

**Apa yang dilakukan:**
- Install Composer dependencies (auto-detect production/dev)
- Frontend install + build assets dengan auto-detect `npm`/`pnpm`/`yarn`/`bun` (hanya pada `--init` / `--update`)
- Run database migrations pada `--init` / `--update` (`--force` otomatis untuk production)
- Enable maintenance mode otomatis saat production `--update` (bisa dipaksa dengan `--maintenance`)
- Clear & rebuild Laravel cache untuk production
- Clear OPCache jika command `opcache:clear` tersedia
- Auto-restart Supervisor worker (jika sudah di-setup)

**Catatan Git update:**
- `deploy --update` memakai `git pull --ff-only` dan akan berhenti jika working tree punya perubahan lokal.
- `deploy --update --force` memakai `git reset --hard` dan `git clean`, lalu meminta konfirmasi.
- Gunakan `deploy --update --force --yes` hanya untuk CI/non-interactive server yang boleh disinkronkan paksa ke branch remote.
- Force clean tetap mengecualikan `.env`, `storage/`, `public/storage/`, dan `public/.well-known/`.

**Konfigurasi opsional `.deployrc`:**

```bash
FORCE_SYNC=false
RUN_MIGRATIONS=auto      # true, false, auto
USE_MAINTENANCE=auto     # true, false, auto
PACKAGE_MANAGER=auto     # auto, npm, pnpm, yarn, bun
WORKER_NAME=myuser-worker
```

`.deployrc` hanya menerima key di atas dan tidak dieksekusi sebagai shell script.

`WORKER_NAME` biasanya tidak perlu diset. `deploy` akan mencoba restart `${user}-worker`, lalu otomatis mencoba `${user}-${domain}-worker` dari nama folder project saat worker dibuat dengan domain eksplisit.

---

### `worker` — Laravel Worker Manager

Manage Laravel queue workers via Supervisor. Jalankan sebagai **root** atau user dengan **sudo**.

| Command | Keterangan |
|---|---|
| `worker create [user] [domain?] [queue?]` | Buat worker baru |
| `worker create [user] [domain?] --install-supervisor` | Izinkan install Supervisor otomatis jika belum ada |
| `worker remove [user] [domain?] [--force]` | Hapus worker |
| `worker list` | List semua workers |
| `worker restart [user] [domain?]` | Restart worker |
| `worker status [user?] [domain?]` | Cek status worker |
| `worker logs [user] [out\|err]` | Tail log worker |

**Control panel yang didukung:**
- CloudPanel (`/home/user/htdocs`)
- FastPanel (`/var/www/user/data/www`)
- Plesk (`/var/www/vhosts/user/httpdocs`)
- cPanel (`/home/user/public_html`)
- Generic (`/var/www/user`)

**Security guard:**
- User harus ada di sistem.
- Owner direktori project harus sama dengan user worker.
- Gunakan `--allow-owner-mismatch` hanya jika ownership berbeda memang disengaja.
- Auto-install Supervisor hanya berjalan jika `--install-supervisor` diberikan.

---

## 📋 Typical Workflow

```bash
# 1. Setup worker (jalankan sekali sebagai root)
sudo worker create myuser example.com

# 2. Masuk ke root project Laravel
cd /path/to/laravel

# 3. Deploy pertama kali
deploy --init

# 4. Update deployment berikutnya
deploy --update

# 5. Cek status worker
worker status myuser example.com

# 6. Tail log worker
worker logs myuser out
```

---

## 🔐 Sudoers Auto-Setup

Saat `worker create` dijalankan, script otomatis membuat entry di `/etc/sudoers.d/` sehingga user dapat melakukan `restart` worker tanpa password. Ini memungkinkan `deploy` me-restart worker secara otomatis tanpa intervensi manual.

Worker dibuat sebagai `${user}-worker` jika domain auto-detected, atau `${user}-${domain}-worker` jika domain diberikan eksplisit. `deploy` dapat auto-detect kedua pola tersebut, jadi `.deployrc` hanya dibutuhkan untuk nama worker custom atau setup yang tidak mengikuti nama folder domain.

Sudoers dibatasi hanya untuk `supervisorctl restart` dan `supervisorctl status` pada worker terkait.

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

Pin versi/tag tertentu:

```bash
LARAVEL_TOOLS_VERSION=v2.0.0 bash install.sh
```

Verifikasi checksum saat install lokal:

```bash
LARAVEL_TOOLS_DEPLOY_SHA256=<sha256> LARAVEL_TOOLS_WORKER_SHA256=<sha256> bash install.sh
```
