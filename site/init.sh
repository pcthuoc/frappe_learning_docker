#!/bin/bash

cd /home/frappe

if [ -f "/home/frappe/frappe-bench/sites/common_site_config.json" ]; then
    echo "✅ Bench already exists, skipping init"
    cd /home/frappe/frappe-bench
    bench start
    exit 0
elif [ -d "/home/frappe/frappe-bench" ] && [ "$(ls -A /home/frappe/frappe-bench)" ]; then
    echo "❌ Directory frappe-bench exists but is not a valid bench, skipping init"
    ls -l /home/frappe/frappe-bench
    exit 1
fi


export PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"

bench init --skip-redis-config-generation frappe-bench

cd frappe-bench

bench set-mariadb-host mariadb
bench set-redis-cache-host redis://redis:6379
bench set-redis-queue-host redis://redis:6379
bench set-redis-socketio-host redis://redis:6379

sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

bench get-app lms
bench new-site lms.localhost --force --mariadb-root-password 123 --admin-password admin --no-mariadb-socket
bench --site lms.localhost install-app lms
bench --site lms.localhost set-config developer_mode 1
bench --site lms.localhost clear-cache
bench use lms.localhost

bench start
