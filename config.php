// ~/ussd_project/config.php
require 'vendor/autoload.php';

use AfricasTalking\SDK\AfricasTalking;

// Set your app credentials
$username   = "Philip Maulidi";  
$apiKey     = "atsk_6e14b37d42c12aa07aed26b80b0294f73590067209dd32a63591fd07d1f74cbdc712f079";  

// Initialize the SDK
$africasTalking = new AfricasTalking($username, $apiKey);

// Get the USSD service
$ussd = $africasTalking->ussd();
