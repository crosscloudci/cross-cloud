# Insightful instructions, originally posted by Xynova (https://github.com/xynova)

# Make socat directories
mkdir -p /opt/bin/socat.d/bin /opt/bin/socat.d/lib

# Create socat wrapper
cat << EOF > /opt/bin/socat
#! /bin/bash
PATH=/usr/bin:/bin:/usr/sbin:/sbin:/opt/bin
LD_LIBRARY_PATH=/opt/bin/socat.d/lib:$LD_LIBRARY_PATH exec /opt/bin/socat.d/bin/socat "\$@"
EOF

chmod +x /opt/bin/socat

# Get socat and libraries from the CoreOS toolbox
toolbox dnf install -y socat
toolbox cp -f /usr/bin/socat /media/root/opt/bin/socat.d/bin/socat
toolbox cp -f /usr/lib64/libssl.so.1.0.2h /media/root/opt/bin/socat.d/lib/libssl.so.10
toolbox cp -f /usr/lib64/libcrypto.so.1.0.2h /media/root/opt/bin/socat.d/lib/libcrypto.so.10
