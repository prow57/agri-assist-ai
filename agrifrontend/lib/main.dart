import 'package:agrifrontend/authentication/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'scan.dart';
import 'theme_notifier.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ScanAdapter());
  await Hive.openBox<Scan>('scans');
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'OpenTechZ App',
          theme: themeNotifier.currentTheme,
          home:  const Signin(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
