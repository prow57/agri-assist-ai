import 'package:flutter/material.dart';

class WeatherHome extends StatelessWidget {
  const WeatherHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: size.height * 0.75,
              width: size.width,
              margin: EdgeInsets.only(right: 10, left: 10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff955cd1),
                    Color(0xff3fa2fa),
                  ]
                ),
              ),
              
            )
          ],
        ),
      ),
    );
  }
}
