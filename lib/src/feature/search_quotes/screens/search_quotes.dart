import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_bloc.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_event.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_state.dart';
import 'package:quotes_app_bloc/src/feature/quotes/widgets/quotes_card.dart';

class SearchQuotes extends StatelessWidget {
  const SearchQuotes({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text('S E A R C H')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchCtrl,
              onChanged: (value) =>
                  context.read<QuotesBloc>().add(SearchQuotesEvent(value)),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter 3 characters to search...',
              ),
            ),
          ),
          BlocBuilder<QuotesBloc, QuotesState>(
            builder: (context, state) {
              if (state is QuotesLoadingState) {
                return Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is QuotesSearchState) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.quotes.length,
                    itemBuilder: (context, index) {
                      final quote = state.quotes[index];
                      return QuotesCard(
                        quote: quote,
                        onSave: () {
                          context.read<QuotesBloc>().add(
                            SaveRemoveQuotesEvent(quote),
                          );
                        },
                        onShare: () {},
                      );
                    },
                  ),
                );
              }

              if (state is QuotesSearchNotFound) {
                return Expanded(
                  child: Center(
                    child: Text(
                      'Not Found',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }

              // if (state is QuotesLoadedState) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.quotes.length,
                  itemBuilder: (context, index) {
                    final quote = state.quotes[index];
                    return QuotesCard(
                      quote: quote,
                      onSave: () {
                        context.read<QuotesBloc>().add(
                          SaveRemoveQuotesEvent(quote),
                        );
                      },
                      onShare: () {},
                    );
                  },
                ),
              );
              // }
            },
          ),
        ],
      ),
    );
  }
}
