# Ergo New Agent Portal - Local Development Guide

## General Information

This document outlines how to set up the Ergo New Agent Portal in a local environment.

---

## 1. Local Environment Setup

1. **Start DDEV**

```bash
ddev start
```

2. **Install Composer dependencies**

```bash
ddev composer install
```

3. **Set up environment file**

```bash
mv .env.ddev.example .env
```

4. **Install WordPress**

```bash
ddev wp core install \
  --url="${DDEV_PRIMARY_URL}" \
  --title="Ergo New Agent Portal" \
  --admin_user=admin \
  --admin_password=admin \
  --admin_email=admin@example.com
```

5. **Launch the site**

```bash
ddev launch
```

---

## 2. Managing Plugins with Composer

> **Important:** Do not install plugins via the WP Admin panel. Always use Composer to ensure consistency across all team members.

### 2.1 Install plugins available on WPackagist

i.e.
```
ddev composer require wpackagist-plugin/advanced-custom-fields
ddev wp plugin activate advanced-custom-fields
```

### 2.2 Install premium or non-WPackagist plugins

Example for **ACF Pro**:

```json
"repositories": [
  {
    "type": "composer",
    "url": "https://wpackagist.org"
  },
  {
    "type": "package",
    "package": {
      "name": "advanced-custom-fields/advanced-custom-fields-pro",
      "version": "6.2.5",
      "type": "wordpress-plugin",
      "dist": {
        "type": "zip",
        "url": "https://connect.advancedcustomfields.com/index.php?p=pro&a=download&t=6.2.5&k=YOUR_LICENSE_KEY"
      },
      "require": {
        "composer/installers": "^2.0",
        "ffraenz/private-composer-installer": "^5.0"
      }
    }
  }
],
"require": {
  "advanced-custom-fields/advanced-custom-fields-pro": "6.2.5"
}
```

Then run:

```bash
ddev composer install
ddev wp plugin activate advanced-custom-fields-pro
```

---

## 3. MU-Plugins (Must-Use Plugins)

**MU-Plugins** are always active and cannot be deactivated via WP Admin.
Use them to store **site-wide configuration, custom post types, and essential hooks**.

**Location:**

```
web/app/mu-plugins/
```

**Example: `site-config.php`**

```php
<?php
/**
 * Site Config - Must-Use Plugin
 * Contains CPTs, filters, and ACF JSON loader.
 */

add_action('init', function() {
    register_post_type('book', [
        'label' => 'Books',
        'public' => true,
        'show_in_rest' => true,
        'supports' => ['title', 'editor', 'thumbnail'],
    ]);
});

// Load ACF JSON
add_filter('acf/settings/save_json', fn() => __DIR__ . '/acf-json');
add_filter('acf/settings/load_json', fn($paths) => array_merge($paths, [__DIR__ . '/acf-json']));
```

**Tips:**

* Commit this file to Git so all team members have the same configuration.
* Place ACF JSON files in `mu-plugins/acf-json/` for automatic loading.

---

## 4. Custom Post Types (CPTs)

```
ddev composer require wpackagist-plugin/custom-post-type-ui
ddev wp plugin activate custom-post-type-ui
```

* Use **CPT UI** plugin to define post types via the admin.
* Export the PHP code from CPT UI → paste it into `mu-plugins/`.
* Recommended to add its custom post type to new php files in `mu-plugins/`.
* Commit the file to Git.

This ensures:

* CPTs are **reproducible** for all team members.
* No need to export/import DB for configuration.

---

## 5. Advanced Custom Fields (ACF) JSON
```
ddev composer require wpackagist-plugin/advanced-custom-fields
ddev wp plugin activate advanced-custom-fields
```
* Enable **Local JSON** to store field groups as JSON files:

```php
add_filter('acf/settings/save_json', fn() => __DIR__ . '/acf-json');
add_filter('acf/settings/load_json', fn($paths) => array_merge($paths, [__DIR__ . '/acf-json']));
```

* When you save field groups in WP Admin, they are automatically stored in `acf-json/`.
* Commit `acf-json/` to Git so teammates get the same fields automatically.

---

## 6. Deployment Notes

* **Install dependencies:**

```bash
composer install --no-dev --optimize-autoloader
```

* **Install WordPress on a new server:**

```bash
wp core install \
  --url=https://example.com \
  --title="Ergo New Agent Portal" \
  --admin_user=admin \
  --admin_password=secret \
  --admin_email=you@example.com
```

* **Activate plugins:**

```bash
ddev wp plugin activate --all
```

> **Note:** Only content (posts, pages, users) lives in the DB. Config (CPTs, ACF, essential plugins) is versioned in Git.

---

## 7. Best Practices

1. Always commit `composer.json` and `composer.lock`.
2. Only commit custom plugins/themes and MU-Plugins; do not commit WordPress core or premium plugin ZIPs.
3. Use **WP-CLI** for plugin activation, DB export/import, and other automated tasks.
4. Keep ACF JSON and CPT config in `mu-plugins` for reproducible setup.
5. Avoid manual changes in WP Admin for configuration that should be shared.
6. Use ```ddev exec ./vendor/bin/pint``` to keep the code style consistent.
---

## 8. Quick Startup for New Developers

```bash
git clone <repo-url>
cd ergo-new-agent-portal
ddev start
ddev composer install
mv .env.ddev.example .env
ddev wp core install --url="${DDEV_PRIMARY_URL}" --title="Ergo New Agent Portal" --admin_user=admin --admin_password=admin --admin_email=admin@example.com
ddev wp plugin activate --all
```

All plugins, CPTs, and ACF fields will now be active and consistent across the team.
