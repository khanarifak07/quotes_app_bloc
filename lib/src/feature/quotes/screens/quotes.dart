import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_bloc.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_event.dart';
import 'package:quotes_app_bloc/src/feature/quotes/bloc/quotes_state.dart';
import 'package:share_plus/share_plus.dart';

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

  void shareQuote(GlobalKey key) async {
    //wait till frame is fully painted
    await WidgetsBinding.instance.endOfFrame;
    //find the widget to take a picture of by quotekey
    final boundry =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    //take the screenshot of the widget
    final image = await boundry.toImage(pixelRatio: 3.0);
    //turn the photo into pngByte
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    //get rawBytes from the image
    final pngByte = byteData!.buffer.asUint8List();
    //find the place to save the image
    final directory = await getTemporaryDirectory();
    //decide the filename
    final filePath = '${directory.path}/quotes.png';
    //save the image on the phone
    final file = File(filePath);
    file.writeAsBytes(pngByte);
    //share the image
    SharePlus.instance.share(
      ShareParams(files: [XFile(filePath)], text: 'Check out this quote!!'),
    );
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
                      context.read<QuotesBloc>().add(
                        ShareQuoteEvent(globalKey: shareQuoteKey),
                      );
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
