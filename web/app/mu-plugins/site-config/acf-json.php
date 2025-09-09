<?php

/**
 * Configure ACF JSON save/load
 */
add_filter('acf/settings/save_json', function () {
    return __DIR__ . '/acf-json';
});

add_filter('acf/settings/load_json', function ($paths) {
    // Keep the default path
    $paths[] = __DIR__ . '/acf-json';
    return $paths;
});
