package com.example.agri

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Update the icons and labels
        setupButton(R.id.scan, R.drawable.ic_scan, R.string.scan)
        setupButton(R.id.weather, R.drawable.ic_weather, R.string.weather)
        setupButton(R.id.advice, R.drawable.ic_advice, R.string.advice)
        setupButton(R.id.soil, R.drawable.ic_soil, R.string.soil)
        setupButton(R.id.price, R.drawable.ic_price, R.string.prices)
        setupButton(R.id.settings, R.drawable.ic_settings, R.string.settings)

        // Add click listener for the scan button
        val scanButton = findViewById<LinearLayout>(R.id.scan)
        scanButton.setOnClickListener {
            val intent = Intent(this, ScanLeafActivity::class.java)
            startActivity(intent)
        }

        // Check if the ID is correct
        val adviceButton = findViewById<LinearLayout>(R.id.advice)
        adviceButton.setOnClickListener {
            val intent = Intent(this, PersonalizeAdviceActivity::class.java)
            startActivity(intent)
        }

        val priceButton = findViewById<LinearLayout>(R.id.price)
        priceButton.setOnClickListener {
            val intent = Intent(this, MarketPriceActivity::class.java)
            startActivity(intent)
        }

        // Add click listener for the weather button
        val weatherButton = findViewById<LinearLayout>(R.id.weather)
        weatherButton.setOnClickListener {
            val intent = Intent(this, WeatherForecastActivity::class.java)
            startActivity(intent)
        }

        // Add click listener for the soil button
        val soilButton = findViewById<LinearLayout>(R.id.soil)
        soilButton.setOnClickListener {
            val intent = Intent(this, SoilDetectionActivity::class.java)
            startActivity(intent)
        }

        // Add click listener for the settings button
        val settingsButton = findViewById<LinearLayout>(R.id.settings)
        settingsButton.setOnClickListener {
            val intent = Intent(this, SettingsActivity::class.java)
            startActivity(intent)
        }
    }

    private fun setupButton(buttonId: Int, iconResId: Int, labelResId: Int) {
        val button = findViewById<android.view.View>(buttonId)
        val icon = button.findViewById<ImageView>(R.id.button_icon)
        val label = button.findViewById<TextView>(R.id.button_label)
        icon.setImageResource(iconResId)
        label.setText(labelResId)
    }
}
