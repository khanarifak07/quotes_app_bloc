import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_bloc.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_event.dart';
import 'package:quotes_app_bloc/src/feature/search_quotes/screens/search_quotes.dart';

class SearchQuotesWrapper extends StatelessWidget {
  const SearchQuotesWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuotesBloc()..add(GetAllQuotesEvent()),
      child: SearchQuotes(),
    );
  }
}
