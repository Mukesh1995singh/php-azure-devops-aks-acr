<?php

// Database Configuration
define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_NAME', getenv('DB_NAME') ?: 'app_db');
define('DB_USER', getenv('DB_USERNAME') ?: (getenv('DB_USER') ?: 'root'));
define('DB_PASS', getenv('DB_PASSWORD') ?: (getenv('DB_PASS') ?: ''));
define('DB_PORT', getenv('DB_PORT') ?: '3306');

// Application Configuration
define('APP_NAME', getenv('APP_NAME') ?: 'PHP Azure DevOps Demo');
define('APP_ENV', getenv('APP_ENV') ?: 'Production');
define('APP_VERSION', getenv('APP_VERSION') ?: '1.0.0');

?>