#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/../../android"

OUT_KEYSTORE="focusfield-release.keystore"
ALIAS="focusfield"
DAYS=10000

read -rp "Keystore file name [${OUT_KEYSTORE}]: " INPUT_FILE
OUT_KEYSTORE=${INPUT_FILE:-$OUT_KEYSTORE}

read -rp "Key alias [${ALIAS}]: " INPUT_ALIAS
ALIAS=${INPUT_ALIAS:-$ALIAS}

read -rsp "Store password: " STORE_PW; echo
read -rsp "Key password (enter to reuse store password): " KEY_PW; echo
KEY_PW=${KEY_PW:-$STORE_PW}

keytool -genkey -v -keystore "${OUT_KEYSTORE}" -alias "${ALIAS}" -keyalg RSA -keysize 2048 -validity ${DAYS}

cat > key.properties <<EOF
storeFile=${OUT_KEYSTORE}
storePassword=${STORE_PW}
keyAlias=${ALIAS}
keyPassword=${KEY_PW}
EOF

echo "\n✅ Created ${OUT_KEYSTORE} and key.properties in android/"
