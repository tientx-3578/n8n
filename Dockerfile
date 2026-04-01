# ============================================================
#  Custom n8n image — n8n 2.12.3 + Python 3
#  Packages KHÔNG baked vào image — quản lý qua requirements.txt
# ============================================================
FROM python:3.13-alpine

# ── System tools ─────────────────────────────────────────────
RUN apk add --no-cache \
        nodejs \
        npm \
        gcc \
        musl-dev \
        bash \
        curl \
        wget \
        git \
        jq \
        su-exec \
        tzdata \
    && ln -sf python3 /usr/bin/python

# ── Install n8n ───────────────────────────────────────────────
RUN npm install -g n8n@2.12.3 --omit=dev

# ── Python task runner source (src/main.py, pyproject.toml) ──
RUN mkdir -p /usr/local/lib/node_modules/@n8n/task-runner-python \
    && wget -qO- https://github.com/n8n-io/n8n/archive/refs/tags/n8n@2.12.3.tar.gz \
       | tar -xz --strip-components=4 \
             -C /usr/local/lib/node_modules/@n8n/task-runner-python \
             "n8n-n8n-2.12.3/packages/@n8n/task-runner-python"

# ── Setup user ────────────────────────────────────────────────
RUN addgroup -S node 2>/dev/null || true \
    && adduser  -S -G node node 2>/dev/null || true \
    && mkdir -p /home/node/.n8n \
    && chown -R node:node /home/node

# ── Entrypoint: khởi tạo venv + cài packages từ requirements.txt
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /home/node
ENV N8N_USER_FOLDER=/home/node/.n8n

EXPOSE 5678
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["n8n", "start"]
