import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app_bloc/src/feature/cubit/cubit/internet_cubit.dart';
import 'package:quotes_app_bloc/src/feature/dashboard/dashboard.dart';
import 'package:quotes_app_bloc/src/utils/utils.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

void main() async {
  Bloc.observer = TalkerBlocObserver(
    settings: TalkerBlocLoggerSettings(
      printEvents: false,
      printStateFullData: false,
      printCreations: true,
      printClosings: true,
      printChanges: false,
      printEventFullData: false,
      printTransitions: false,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Utils.initSF();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetCubit(connectivity: Connectivity()),
      child: MaterialApp(home: Dashboard()),
    );
  }
}
