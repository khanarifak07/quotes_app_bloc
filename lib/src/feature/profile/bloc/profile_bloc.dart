import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quotes_app_bloc/src/feature/profile/bloc/profile_event.dart';
import 'package:quotes_app_bloc/src/feature/profile/bloc/profile_state.dart';
import 'package:quotes_app_bloc/src/services/api_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on(_getAllAuthors);
  }

  List<String> allAuthors = [];

  void _getAllAuthors(
    GetAllAuthorsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoadingState());
      final url = Uri.parse(ApiService.getAllQuotes);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['quotes'] as List;
        allAuthors = data
            .map<String>((e) => e['author'].toString())
            .toSet()
            .toList();
        emit(GetAllAuthorsState(allAuthors));
      }
    } catch (e) {
      log('Error while getting all authors $e');
    }
  }
}
