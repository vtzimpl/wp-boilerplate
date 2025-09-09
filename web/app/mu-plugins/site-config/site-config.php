<?php
/**
 * Plugin Name: Site Config
 * Description: Custom site configuration (CPTs, taxonomies, ACF JSON, etc.)
 * Author: Netcompany
 */

if (!defined('ABSPATH')) {
    exit;
}

// Autoload all PHP files in this folder (except index.php and this file)
foreach (glob(__DIR__ . '/*.php') as $file) {
    if (basename($file) === 'site-config.php' || basename($file) === 'index.php') {
        continue;
    }
    require_once $file;
}
