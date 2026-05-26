import 'package:dio_viacep/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta e cadastro de CEP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const MainPage(title: 'Consulta e cadastro de CEP'),
    );
  }
}