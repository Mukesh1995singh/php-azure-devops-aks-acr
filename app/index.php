<?php
require_once 'config.php';
require_once 'db.php';

$hostname = gethostname() ?: 'Unknown Host';
$phpVersion = phpversion();
$date = date("Y-m-d H:i:s");

$dbStatus = "Not Connected";
$dbMessage = "No database connection established.";

// Check if $pdo object was initialized in db.php
if (isset($pdo) && $pdo instanceof PDO) {
    try {
        $stmt = $pdo->query("SELECT NOW() AS current_time");
        $row = $stmt->fetch();

        if ($row && isset($row['current_time'])) {
            $dbStatus = "Connected";
            $dbMessage = "Database Time: " . $row['current_time'];
        }
    } catch (Exception $e) {
        $dbStatus = "Connection Failed";
        $dbMessage = (defined('APP_ENV') && strtolower(APP_ENV) === 'production') 
            ? "Database query failed." 
            : $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars(APP_NAME, ENT_QUOTES, 'UTF-8'); ?></title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            text-align: center;
            padding: 40px;
            margin: 0;
        }

        .container {
            max-width: 850px;
            margin: auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,.15);
        }

        h1 {
            color: #0078D4;
            margin-top: 0;
        }

        h2 {
            color: #2E7D32;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table th, table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }

        table th {
            background: #0078D4;
            color: #ffffff;
        }

        .success {
            color: #2e7d32;
            font-weight: bold;
        }

        .error {
            color: #d32f2f;
            font-weight: bold;
        }

        footer {
            margin-top: 25px;
            color: #555;
            font-size: 0.9em;
        }
    </style>
</head>

<body>

<div class="container">

    <h1><?php echo htmlspecialchars(APP_NAME, ENT_QUOTES, 'UTF-8'); ?></h1>

    <h2>Application Successfully Deployed on Azure Kubernetes Service</h2>

    <p>This project demonstrates an end-to-end Azure DevOps CI/CD pipeline.</p>

    <h3>Technologies Used</h3>

    <ul style="text-align: left; display: inline-block;">
        <li>GitHub</li>
        <li>Azure DevOps</li>
        <li>Docker</li>
        <li>Azure Container Registry (ACR)</li>
        <li>Azure Kubernetes Service (AKS)</li>
        <li>Azure Key Vault</li>
        <li>Azure Database for MySQL</li>
        <li>Kubernetes ConfigMap</li>
        <li>Secrets Store CSI Driver</li>
        <li>PHP 8.2</li>
    </ul>

    <h3>Application Information</h3>

    <table>
        <tr>
            <th>Property</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Application Name</td>
            <td><?php echo htmlspecialchars(APP_NAME, ENT_QUOTES, 'UTF-8'); ?></td>
        </tr>
        <tr>
            <td>Environment</td>
            <td><?php echo htmlspecialchars(APP_ENV, ENT_QUOTES, 'UTF-8'); ?></td>
        </tr>
        <tr>
            <td>Version</td>
            <td><?php echo htmlspecialchars(APP_VERSION, ENT_QUOTES, 'UTF-8'); ?></td>
        </tr>
        <tr>
            <td>Container Hostname</td>
            <td><?php echo htmlspecialchars($hostname, ENT_QUOTES, 'UTF-8'); ?></td>
        </tr>
        <tr>
            <td>PHP Version</td>
            <td><?php echo htmlspecialchars($phpVersion, ENT_QUOTES, 'UTF-8'); ?></td>
        </tr>
        <tr>
            <td>Deployment Time</td>
            <td><?php echo htmlspecialchars($date, ENT_QUOTES, 'UTF-8'); ?></td>
        </tr>
        <tr>
            <td>Database Status</td>
            <td class="<?php echo ($dbStatus === "Connected") ? "success" : "error"; ?>">
                <?php echo htmlspecialchars($dbStatus, ENT_QUOTES, 'UTF-8'); ?>
            </td>
        </tr>
        <tr>
            <td>Database Response</td>
            <td><?php echo htmlspecialchars($dbMessage, ENT_QUOTES, 'UTF-8'); ?></td>
        </tr>
    </table>

    <footer>
        <b>DevOps Portfolio Project</b><br>
        CI/CD • Docker • Azure DevOps • ACR • AKS • Azure Key Vault • Azure Database for MySQL
    </footer>

</div>

</body>
</html>