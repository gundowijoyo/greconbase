#!/usr/bin/env bash
# ==============================================================================
# Tool Name    : GreconBase
# Description  : All-in-One External Passive Recon & Stealth Server Auditor
# Author       : Gundo Wijoyo / @gundowijoyo
# Version      : 1.0.0
# ==============================================================================

# Warna untuk output terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' 

# Banner Tool
show_banner() {
    echo -e "${CYAN}"
    echo "   ______                               ____                  "
    echo "  / ____/________  _________  ____     / __ )____ ___________ "
    echo " / / __/ ___/ _ \/ ___/ __ \/ __ \   / __  / __ \`/ ___/ _ \\"
    echo "/ /_/ / /  /  __/ /__/ /_/ / / / /  / /_/ / /_/ (__  )  __/"
    echo "\____/_/   \___/\___/\____/_/ /_/  /_____/\__,_/____/\___/ "
    echo -e "                 [ Monolithic Stealth Recon Framework ]${NC}\n"
}

# Bantuan Penggunaan
show_help() {
    echo "Penggunaan: $0 <domain> [opsi]"
    echo ""
    echo "Opsi:"
    echo "  -s, --stealth    Aktifkan Anti-Deteksi Bot (Rotasi User-Agent & Jeda Acak)"
    echo "  -h, --help       Tampilkan menu bantuan"
    echo ""
    echo "Contoh: $0 target.com --stealth"
    exit 0
}

# Parsing Input
TARGET=""
STEALTH_MODE=false

if [ $# -eq 0 ]; then show_banner; show_help; fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) show_banner; show_help ;;
        -s|--stealth) STEALTH_MODE=true; shift ;;
        *)
            if [ -z "$TARGET" ]; then TARGET="$1"; else
                echo -e "${RED}[!] Kesalahan: Argumen tidak dikenal '$1'${NC}"; exit 1
            fi
            shift
            ;;
    esac
done

# Bersihkan input domain dari https:// atau http://
TARGET=$(echo "$TARGET" | sed -e 's|^[^/]*//||' -e 's|/.*||')
if [ -z "$TARGET" ]; then
    echo -e "${RED}[!] Kesalahan: Domain target wajib diisi!${NC}"; show_help
fi

show_banner
echo -e "${BLUE}[*] Memulai investigasi eksternal pada:${NC} ${YELLOW}$TARGET${NC}"
echo -e "${BLUE}[*] Tanggal Audit:${NC} $(date)"
echo -e "----------------------------------------------------------------"

# ==============================================================================
# MODUL 1: STEALTH & PENYAMARAN BOT (CORE ENGINE)
# ==============================================================================
if [ "$STEALTH_MODE" = true ]; then
    echo -e "${GREEN}[✓] Mode Stealth AKTIF (Menghindari pemblokiran WAF/Bot Detector)${NC}"
else
    echo -e "${YELLOW}[!] Mode Stealth NON-AKTIF (Koneksi langsung standar)${NC}"
fi

fetch_url() {
    local url=$1
    local extra_args=$2
    
    if [ "$STEALTH_MODE" = true ]; then
        # Rotasi User-Agent agar disangka manusia (Chrome/Safari/Edge terbaru)
        local user_agents=(
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15"
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
        )
        local random_ua=${user_agents[$RANDOM % ${#user_agents[@]}]}
        
        # Jeda acak (Anti-Rate Limiting) 1 hingga 3 detik
        sleep $((1 + RANDOM % 3))
        
        # Eksekusi dengan header manipulasi (Googlebot Referer & Fake IP)
        curl -s -L $extra_args -A "$random_ua" \
            -H "Referer: https://google.com" \
            -H "X-Forwarded-For: 64.233.160.$((1 + RANDOM % 254))" \
            "$url"
    else
        curl -s -L $extra_args "$url"
    fi
}

# ==============================================================================
# MODUL 2: WAF IDENTIFICATION (Mendeteksi Tembok Api Target)
# ==============================================================================
echo -e "\n${CYAN}[1/3] 🛡️ FASE 1: AUDIT & IDENTIFIKASI WAF${NC}"
echo -e "    [*] Memeriksa response headers..."

# Mengambil header HTTP dari target
HEADERS=$(fetch_url "https://$TARGET" "-I")

WAF_FOUND="Tidak Terdeteksi (Kemungkinan Clear / Direct Server)"

if echo "$HEADERS" | grep -iq "cloudflare"; then
    WAF_FOUND="Cloudflare 🛡️"
elif echo "$HEADERS" | grep -iq "sucuri"; then
    WAF_FOUND="Sucuri WAF 🛡️"
elif echo "$HEADERS" | grep -iq "Incapsula"; then
    WAF_FOUND="Imperva Incapsula 🛡️"
elif echo "$HEADERS" | grep -iq "AWSALB" || echo "$HEADERS" | grep -iq "awswaf"; then
    WAF_FOUND="Amazon Web Services (AWS) WAF 🛡️"
fi

echo -e "    └── Status Firewall: ${YELLOW}$WAF_FOUND${NC}"

# ==============================================================================
# MODUL 3: MAPPING INFO & FINGERPRINTING TERSEMBUNYI
# ==============================================================================
echo -e "\n${CYAN}[2/3] 🔍 FASE 2: PEMETAAN DETIL & SERVER FOOTPRINT${NC}"

# 1. Pengecekan Server Web Banner
SERVER_BANNER=$(echo "$HEADERS" | grep -i "server:" | awk '{print $2}' | tr -d '\r')
if [ -z "$SERVER_BANNER" ]; then SERVER_BANNER="Disembunyikan / Diaburkan"; fi
echo -e "    ├── Web Server Engine   : ${YELLOW}$SERVER_BANNER${NC}"

# 2. Pengecekan Teknologi via Powered-By
POWERED_BY=$(echo "$HEADERS" | grep -i "x-powered-by:" | awk '{print $2}' | tr -d '\r')
if [ -z "$POWERED_BY" ]; then POWERED_BY="Tidak Dibocorkan (Aman)"; fi
echo -e "    ├── Teknologi Backend   : ${YELLOW}$POWERED_BY${NC}"

# 3. Pengecekan IP Asli Publik (DNS Lookup)
IP_ADDR=$(dig +short "$TARGET" | tail -n1)
if [ -z "$IP_ADDR" ]; then IP_ADDR=$(nslookup "$TARGET" 2>/dev/null | awk '/Address: / { print $2 }' | tail -n1); fi
echo -e "    ├── IP Publik Terbuka   : ${YELLOW}${IP_ADDR:-Tidak Diketahui}${NC}"

# 4. Pengecekan Direktori / File Sensitif yang Terbuka (Stealth Fuzzing)
echo -e "    └── Memindai Kebocoran File Sensitif (Low Profile Scan):"
files=(".env" ".git/config" "robots.txt" "wp-config.php.bak" "config.json")

for file in "${files[@]}"; do
    # Kirim request HEAD untuk mengecek status HTTP tanpa mendownload seluruh isi file
    STATUS=$(fetch_url "https://$TARGET/$file" "-o /dev/null -w %{http_code}")
    
    if [ "$STATUS" == "200" ]; then
        echo -e "        ├──  /${file} -> ${RED}[200 OK] ❌ RAWAN BOCOR!${NC}"
    elif [ "$STATUS" == "403" ]; then
        echo -e "        ├──  /${file} -> ${GREEN}[403 Forbidden] (Aman / Dilindungi)${NC}"
    else
        echo -e "        ├──  /${file} -> [${STATUS}] (Tidak Ditemukan / Aman)"
    fi
done

# ==============================================================================
# MODUL 4: PEMBUATAN LAPORAN (REPORT GENERATOR)
# ==============================================================================
echo -e "\n${CYAN}[3/3] 📊 FASE 3: GENERATE RECON SUMMARY${NC}"
mkdir -p reports
REPORT_PATH="reports/${TARGET}_recon.md"

cat <<EOF > "$REPORT_PATH"
# 📊 GreconBase Security Report - ${TARGET}
*Dibuat pada: $(date)*

## 🛡️ Firewall & Evasion Status
- **WAF Detected:** $WAF_FOUND
- **Stealth Scan Engaged:** $STEALTH_MODE

## 🔍 Server Footprint
- **Web Server:** $SERVER_BANNER
- **Backend Infrastructure:** $POWERED_BY
- **Resolved IP:** $IP_ADDR

---
*GreconBase Framework - Diproduksi untuk kebutuhan Security Auditing Terotorisasi.*
EOF

echo -e "${GREEN}[✓] Semua proses sukses! Hasil pemetaan disimpan di: ${YELLOW}$REPORT_PATH${NC}\n"
