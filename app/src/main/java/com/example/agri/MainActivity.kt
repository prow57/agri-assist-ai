package com.example.agri

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Find the button by its ID
        val scanLeafButton: Button = findViewById(R.id.scan)

        // Set an OnClickListener on the button
        scanLeafButton.setOnClickListener {
            // Create an Intent to start the ScanLeafActivity
            val intent = Intent(this, ScanLeafActivity::class.java)
            startActivity(intent)
        }
    }
}