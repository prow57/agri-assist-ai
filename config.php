// /path/to/your/project/config.php
require 'vendor/autoload.php';

use AfricasTalking\SDK\AfricasTalking;
use Dotenv\Dotenv;

// Load environment variables from .env file
$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->load();

// Set your app credentials from environment variables
$username   = $_ENV['AFRICASTALKING_USERNAME'];
$apiKey     = $_ENV['AFRICASTALKING_API_KEY'];

// Initialize the SDK
$africasTalking = new AfricasTalking($username, $apiKey);

// Get the USSD service
$ussd = $africasTalking->ussd();
