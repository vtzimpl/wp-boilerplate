<?php
/**
 * Register "Contract" custom post type
 */
add_action('init', function () {
    register_post_type('book', [
        'labels' => [
            'name'          => __('Contracts'),
            'singular_name' => __('Contract'),
        ],
        'public'       => true,
        'has_archive'  => true,
        'show_in_rest' => true, // enables Gutenberg + API
        'supports'     => ['title', 'editor', 'thumbnail', 'excerpt'],
        'menu_icon'    => 'dashicons-book-alt',
    ]);
});
