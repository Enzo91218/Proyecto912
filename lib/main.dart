import 'package:flutter/material.dart';
import 'Presentacion/router.dart';
import 'inyector/main.dart' as inyector;

void main() {
  inyector.setupInyector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Proyecto912',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
