<?php

require_once 'config.php';

try {
    // Check if database host is configured
    if (!DB_HOST || !DB_NAME) {
        throw new Exception("Database host or database name is not configured.");
    }

    $dsn = "mysql:host=" . DB_HOST .
           ";port=" . DB_PORT .
           ";dbname=" . DB_NAME .
           ";charset=utf8mb4";

    $pdo = new PDO($dsn, DB_USER, DB_PASS, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
        PDO::ATTR_PERSISTENT         => false,
    ]);

} catch (PDOException $e) {
    // Log detailed error internally for debugging in Kubernetes container logs
    error_log("Database Connection Error: " . $e->getMessage());

    // Display generic error to end users to prevent credential/internal info leaks
    if (defined('APP_ENV') && strtolower(APP_ENV) === 'production') {
        die("Database connection failed. Please try again later.");
    } else {
        die("Database connection failed: " . $e->getMessage());
    }
} catch (Exception $e) {
    error_log("Config Error: " . $e->getMessage());
    die($e->getMessage());
}

?>