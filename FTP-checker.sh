#!/bin/bash

FTP_HOST="127.0.0.1"
FTP_PORT="21"
FTP_USER="ftpuser"
FTP_PASS="SecurePassword123!"

TEST_FILE="ftp_test.txt"

echo "=== Test FTP automatique ==="

echo "FTP TEST OK" > $TEST_FILE

ftp -inv $FTP_HOST $FTP_PORT <<EOF
user $FTP_USER $FTP_PASS
quote PASV
put $TEST_FILE
get $TEST_FILE downloaded_$TEST_FILE
bye
EOF

if [ -f "downloaded_$TEST_FILE" ]; then
    echo "✅ FTP fonctionne parfaitement (PASSIF OK)"
else
    echo "❌ Erreur FTP"
fi

rm -f $TEST_FILE downloaded_$TEST_FILE
