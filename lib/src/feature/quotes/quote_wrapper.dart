import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_bloc.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_event.dart';
import 'package:quotes_app_bloc/src/feature/quotes/screens/quotes.dart';

class QuoteWrapper extends StatelessWidget {
  const QuoteWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuotesBloc()..add(GetAllQuotesByPaginationEvent()),
      child: Quotes(),
    );
  }
}
