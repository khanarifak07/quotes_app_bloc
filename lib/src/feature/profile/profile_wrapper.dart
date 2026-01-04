import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app_bloc/src/feature/profile/bloc/profile_bloc.dart';
import 'package:quotes_app_bloc/src/feature/profile/screens/profile.dart';

class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => ProfileBloc(), child: Profile());
  }
}
