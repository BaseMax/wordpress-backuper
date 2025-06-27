# 📦 Wordpress Backuper

**Wordpress-Backuper** is a shell script by [Max Base](https://github.com/BaseMax) designed to create structured, compressed backups of a WordPress site-specifically focusing on core files, `wp-content`, and `uploads` by year.

---

## ✅ Features

- Zips the root directory (excluding `.zip`, `.gz`, `.sql`, etc.)
- Separately zips `wp-content` (excluding `uploads`)
- Scans `uploads/` for folders like `2020`, `2021`, etc., and zips each one independently
- Generates an `others.zip` for non-year subdirectories in `uploads`
- Logs all actions to `zip_process.log`
- Supports dry-run and verbose modes
- Safe: skips zip files that already exist

---

## 🧰 Requirements

- `zip`
- `find`
- Bash (Linux/macOS)

Install missing dependencies (Debian-based example):

```bash
sudo apt install zip findutils
````

---

## 🚀 Usage

### Quickly

```bash
curl -L -o wordpress-backuper.sh https://github.com/BaseMax/wordpress-backuper/raw/refs/heads/main/wordpress-backuper.sh
chmod +x wordpress-backuper.sh
./wordpress-backuper.sh
```

### Clone the repo:

```bash
git clone https://github.com/BaseMax/Wordpress-Backuper.git
cd Wordpress-Backuper
```

### Run the script:

```bash
./wordpress-backuper.sh
```

### Options

| Option | Description                   |
| ------ | ----------------------------- |
| `-v`   | Verbose mode (print log live) |
| `-n`   | Dry-run (simulate, no zip)    |
| `-h`   | Show help                     |

### Example:

```bash
./wordpress-backuper.sh -v
```

---

## 📁 Output Files

All zip files are saved in the root directory:

* `root.zip` — All root files except `wp-content` and known archive formats
* `wp-content.zip` — All content except `uploads/`
* `2020.zip`, `2021.zip`, ... — Individual zip files for each year in `uploads`
* `others.zip` — Remaining contents of `uploads/` excluding year folders

Log file:

* `zip_process.log` — Full log of the operation

---

## 🧪 Example Directory Structure

```
.
├── index.php
├── wp-content/
│   └── uploads/
│       ├── 2021/
│       ├── 2022/
│       ├── other-dir/
```

After running the script, you’ll get:

```
root.zip
wp-content.zip
2021.zip
2022.zip
2....zip
others.zip
zip_process.log
```

---

## 📬 Feedback & Contributions

Suggestions, issues, and pull requests are welcome via [GitHub Issues](https://github.com/BaseMax/Wordpress-Backuper/issues).

---

## 🙏 Credits

* Developed by [Max Base](https://github.com/BaseMax)
* Script licensed under the MIT License
