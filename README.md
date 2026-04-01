# n8n Docker — Self-hosted Workflow Automation

> **n8n** phiên bản self-hosted chạy trên Docker, tích hợp sẵn **Python Task Runner** để viết Code node bằng Python.

---

## 📋 Yêu cầu

| Phần mềm | Phiên bản tối thiểu |
|----------|---------------------|
| Docker | 24+ |
| Docker Compose | v2+ |
| Git | bất kỳ |

---

## 🚀 Cài đặt nhanh

### 1. Clone repository

```bash
git clone https://github.com/tientx-3578/n8n.git
cd n8n
```

### 2. Tạo file cấu hình

```bash
cp .env.example .env
```

Mở file `.env` và chỉnh các giá trị quan trọng:

```dotenv
# QUAN TRỌNG: đổi key này trước khi chạy lần đầu!
N8N_ENCRYPTION_KEY=your-random-secret-key

# Nếu chạy local
N8N_HOST=localhost
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/

# Nếu deploy server thật (thay bằng domain của bạn)
# N8N_HOST=n8n.yourdomain.com
# N8N_PROTOCOL=https
# WEBHOOK_URL=https://n8n.yourdomain.com/
```

### 3. Tạo thư mục cần thiết

```bash
mkdir -p python-venv local-files
```

### 4. Build và khởi động

```bash
docker compose up -d --build
```

Lần đầu chạy sẽ mất vài phút để:
- Build Docker image
- Tạo Python virtual environment
- Cài tất cả packages trong `requirements.txt`

### 5. Truy cập

Mở trình duyệt: **http://localhost:5678**

---

## 📦 Quản lý Python packages

Thêm package vào file `requirements.txt`, ví dụ:

```
scipy>=1.13.0
```

Sau đó restart container để tự động cài:

```bash
docker compose restart
```

Packages mặc định đã có sẵn:

| Package | Mục đích |
|---------|----------|
| `requests`, `httpx` | HTTP / API calls |
| `pandas`, `numpy` | Xử lý dữ liệu |
| `beautifulsoup4`, `lxml` | Web scraping |
| `psycopg2-binary`, `pymysql` | Kết nối database |
| `redis` | Cache / Queue |
| `boto3` | AWS / S3 |
| `paramiko`, `cryptography` | SSH / Crypto |
| `Pillow` | Xử lý ảnh |
| `python-dotenv`, `pyyaml`, `jinja2` | Config / Template |

---

## 🗂️ Cấu trúc thư mục

```
n8n/
├── Dockerfile              # Build image n8n + Python
├── docker-compose.yml      # Cấu hình services
├── docker-entrypoint.sh    # Script khởi động (tạo venv, cài packages)
├── requirements.txt        # Python packages cần cài
├── .env.example            # Mẫu biến môi trường
├── .env                    # Biến môi trường thực (không commit)
├── python-venv/            # Python virtual environment (không commit)
└── local-files/            # Thư mục chia sẻ file host ↔ container
```

---

## 🔄 Các lệnh thường dùng

```bash
# Khởi động
docker compose up -d

# Dừng
docker compose down

# Xem logs
docker compose logs -f n8n

# Rebuild image (sau khi sửa Dockerfile)
docker compose up -d --build

# Restart (sau khi thêm package vào requirements.txt)
docker compose restart
```

---

## 🖥️ Deploy lên server

1. Sửa file `.env`:
   ```dotenv
   N8N_HOST=n8n.yourdomain.com
   N8N_PROTOCOL=https
   WEBHOOK_URL=https://n8n.yourdomain.com/
   N8N_EDITOR_BASE_URL=https://n8n.yourdomain.com
   ```

2. Cấu hình reverse proxy (Nginx/Caddy) trỏ port `5678`

3. Khởi động:
   ```bash
   docker compose up -d --build
   ```

---

## ⚠️ Lưu ý

- **Không commit** file `.env` lên git (đã có trong `.gitignore`)
- Dữ liệu n8n (workflows, credentials) lưu trong Docker volume `n8n_data`
- Backup volume `n8n_data` định kỳ để tránh mất dữ liệu

