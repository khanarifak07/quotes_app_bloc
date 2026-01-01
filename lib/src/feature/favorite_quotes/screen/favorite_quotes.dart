import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../quotes/bloc/quotes_bloc.dart';
import '../../quotes/bloc/quotes_event.dart';
import '../../quotes/bloc/quotes_state.dart';
import '../../quotes/widgets/quotes_card.dart';

class FavoriteQuotes extends StatefulWidget {
  const FavoriteQuotes({super.key});

  @override
  State<FavoriteQuotes> createState() => _FavoriteQuotesState();
}

class _FavoriteQuotesState extends State<FavoriteQuotes> {
  @override
  void didUpdateWidget(FavoriteQuotes oldWidget) {
    super.didUpdateWidget(oldWidget);
    context.read<QuotesBloc>().add(GetFavotireQuotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('F A V O R I T E S')),
      body: BlocConsumer<QuotesBloc, QuotesState>(
        builder: (context, state) {
          if (state is QuotesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is QuotesFailureState) {
            return Center(child: Text(state.message));
          }
          if (state is QuotesLoadedState) {
            final quotes = state.quotes;
            return ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final shareKey = GlobalKey();
                final quote = quotes[index];
                return RepaintBoundary(
                  key: shareKey,
                  child: QuotesCard(
                    quote: quote,
                    onSave: () {
                      context.read<QuotesBloc>().add(
                        SaveRemoveQuotesEvent(quote),
                      );
                    },
                    onShare: () {
                      context.read<QuotesBloc>().add(
                        ShareQuoteEvent(globalKey: shareKey),
                      );
                    },
                  ),
                );
              },
            );
          }
          return SizedBox.shrink();
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
