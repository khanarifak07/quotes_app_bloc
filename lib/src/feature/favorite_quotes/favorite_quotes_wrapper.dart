import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app_bloc/src/feature/favorite_quotes/screen/favorite_quotes.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_bloc.dart';

class FavoriteQuotesWrapper extends StatelessWidget {
  const FavoriteQuotesWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => QuotesBloc(true), child: FavoriteQuotes());
  }
}
