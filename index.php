<?php
echo "<!DOCTYPE html>";
echo "<html>";
echo "<head>";
echo "<title>Azure DevOps CI/CD Version 1.1</title>";
echo "<style>";
echo "body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; background-color: #f4f4f4; }";
echo "h1 { color: #0078D4; }";
echo "h2 { color: green; }";
echo "p { font-size: 18px; }";
echo "</style>";
echo "</head>";
echo "<body>";

echo "<h1>Azure DevOps CI/CD Project</h1>";
echo "<h2>Application Successfully Deployed on AKS</h2>";
echo "<p>Containerized using Docker</p>";
echo "<p>Image stored in Azure Container Registry (ACR)</p>";
echo "<p>Application deployed to Azure Kubernetes Service (AKS)</p>";

echo "<hr>";
echo "<h3>Server Information</h3>";
echo "Hostname: " . gethostname() . "<br>";
echo "PHP Version: " . phpversion();

echo "</body>";
echo "</html>";
?>