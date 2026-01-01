import 'package:flutter/material.dart';
import 'package:quotes_app_bloc/src/feature/dashboard/dashboard.dart';
import 'package:quotes_app_bloc/src/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Utils.initSF();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Dashboard());
  }
}
