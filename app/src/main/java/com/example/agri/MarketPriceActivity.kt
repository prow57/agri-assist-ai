package com.example.agri

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar

class MarketPriceActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_market_price)

        // Set up the toolbar with a back arrow
//        val toolbar: Toolbar = findViewById(R.id.toolbar)
//        setSupportActionBar(toolbar)

//        val actionBar = supportActionBar
//        actionBar?.setDisplayHomeAsUpEnabled(true)
//        actionBar?.setHomeAsUpIndicator(R.drawable.ic_back_arrow) // Ensure this icon exists
//        actionBar?.title = ""
//
//        toolbar.setNavigationOnClickListener {
//            onBackPressed()
//        }
    }
}
