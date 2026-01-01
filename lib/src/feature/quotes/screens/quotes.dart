import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_bloc.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_event.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_state.dart';
import 'package:quotes_app_bloc/src/utils/utils.dart';

import '../widgets/quotes_card.dart';

class Quotes extends StatefulWidget {
  const Quotes({super.key});

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_handleListener);
    super.initState();
  }

  void _handleListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<QuotesBloc>().add(GetAllQuotesByPaginationEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final quoteBloc = context.read<QuotesBloc>();
    return Scaffold(
      appBar: AppBar(title: Text('Q U O T E S')),
      body: BlocConsumer<QuotesBloc, QuotesState>(
        builder: (context, state) {
          if (state is QuotesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is QuotesFailureState) {
            return Center(child: Text(state.message));
          }
          // if (state is QuotesLoadedState) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.quotes.length + (quoteBloc.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.quotes.length) {
                GlobalKey shareQuoteKey = GlobalKey();
                final quote = state.quotes[index];
                return RepaintBoundary(
                  key: shareQuoteKey,
                  child: QuotesCard(
                    quote: quote,
                    onSave: () {
                      context.read<QuotesBloc>().add(
                        SaveRemoveQuotesEvent(quote),
                      );
                    },
                    onShare: () {
                      Utils.shareQuote(shareQuoteKey);
                    },
                  ),
                );
              }

              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          );
          // }
        },
        listener: (context, state) {
          if (state is QuotesSavedState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Quote saved ❤️')));
          }
          if (state is QuotesRemovedState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Quote removed 💔')));
          }
        },
      ),
    );
  }
}
