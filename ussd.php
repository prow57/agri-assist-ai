// ~/ussd_project/ussd.php
require 'config.php';

// Read the variables sent via POST from the API
$sessionId   = $_POST["sessionId"];
$serviceCode = $_POST["serviceCode"];
$phoneNumber = $_POST["phoneNumber"];
$text        = $_POST["text"];

// This is the first menu screen
if ($text == "") {
    $response  = "CON Welcome to AI-Driven Agricultural Advisory System\n";
    $response .= "1. Get Farming Advice\n";
    $response .= "2. Get Weather Forecast\n";
    $response .= "3. Market Prices\n";
} else if ($text == "1") {
    $response  = "CON Select the type of advice you need\n";
    $response .= "1. Planting\n";
    $response .= "2. Irrigation\n";
    $response .= "3. Fertilization\n";
} else if ($text == "2") {
    $response  = "CON Select your region\n";
    $response .= "1. North\n";
    $response .= "2. Central\n";
    $response .= "3. South\n";
} else if ($text == "3") {
    $response  = "CON Select the crop\n";
    $response .= "1. Maize\n";
    $response .= "2. Rice\n";
    $response .= "3. Tobacco\n";
} else if ($text == "1*1") {
    $advice = getPlantingAdvice();
    $response = "END Planting advice: $advice";
} else if ($text == "1*2") {
    $advice = getIrrigationAdvice();
    $response = "END Irrigation advice: $advice";
} else if ($text == "1*3") {
    $advice = getFertilizationAdvice();
    $response = "END Fertilization advice: $advice";
} else if ($text == "2*1") {
    $forecast = getWeatherForecast("North");
    $response = "END Weather forecast for the North: $forecast";
} else if ($text == "2*2") {
    $forecast = getWeatherForecast("Central");
    $response = "END Weather forecast for the Central region: $forecast";
} else if ($text == "2*3") {
    $forecast = getWeatherForecast("South");
    $response = "END Weather forecast for the South: $forecast";
} else if ($text == "3*1") {
    $price = getMarketPrice("Maize");
    $response = "END Market price for Maize: $price";
} else if ($text == "3*2") {
    $price = getMarketPrice("Rice");
    $response = "END Market price for Rice: $price";
} else if ($text == "3*3") {
    $price = getMarketPrice("Tobacco");
    $response = "END Market price for Tobacco: $price";
}

// Echo the response back to the API
header('Content-type: text/plain');
echo $response;

function getPlantingAdvice() {
    return "Use improved seed varieties and practice crop rotation.";
}

function getIrrigationAdvice() {
    return "Irrigate your crops early in the morning or late in the evening.";
}

function getFertilizationAdvice() {
    return "Apply organic fertilizers and avoid over-fertilization.";
}

function getWeatherForecast($region) {
    return "Sunny with a chance of rain in the afternoon.";
}

function getMarketPrice($crop) {
    return "The current price for $crop is MWK 200 per kg.";
}
