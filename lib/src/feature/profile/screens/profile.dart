import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app_bloc/src/feature/profile/bloc/profile_bloc.dart';
import 'package:quotes_app_bloc/src/feature/profile/bloc/profile_event.dart';
import 'package:quotes_app_bloc/src/feature/profile/bloc/profile_state.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(GetAllAuthorsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('A U T H O R S')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetAllAuthorsState) {
            return ListView.builder(
              itemCount: state.authors.length,
              itemBuilder: (context, index) {
                final author = state.authors[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ).copyWith(bottom: 10),
                  child: ListTile(
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(author),
                    tileColor: Colors.red[100],
                  ),
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
