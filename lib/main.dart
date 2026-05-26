import 'package:dio_viacep/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Carrega o dotenv
  await dotenv.load();

  // Roda o App
  runApp(const MyApp());
}
