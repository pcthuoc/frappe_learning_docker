FROM ninjaclasher/dmoj-base

# Copy script
COPY site/init.sh /home/frappe/init.sh

# Đặt quyền thực thi cho script
USER root
RUN chmod +x /home/frappe/init.sh

# Chạy với quyền frappe
USER frappe
WORKDIR /home/frappe
