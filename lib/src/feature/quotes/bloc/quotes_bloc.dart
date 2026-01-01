import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'quotes_event.dart';
import 'quotes_state.dart';
import '../model/quote_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_transform/stream_transform.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  QuotesBloc() : super(QuotesInitialState()) {
    on<GetAllQuotesEvent>(_getAllQuotesEvents);
    on<GetAllQuotesByPaginationEvent>(_getAllQuotesByPagination);
    on<SearchQuotesEvent>(
      _searchQuotesEvent,
      transformer: debouce(Durations.medium3),
    );
    on<SaveRemoveQuotesEvent>(_saveRemoveQuotesEvent);
    on<ShareQuoteEvent>(_shareQuoteEvent);
    on<GetFavotireQuotesEvent>(_loadFavoriteQuotes);
  }

  List<QuoteModel> quotes = [];
  List<QuoteModel> paginationQuotes = [];
  List<QuoteModel> searchQuotesResult = [];
  List<QuoteModel> favoriteQuotes = [];

  int skip = 0;
  int limit = 10;
  bool hasMore = true;
  bool isLoading = false;

  TextEditingController searchCtrl = TextEditingController();

  //
  void _getAllQuotesEvents(
    GetAllQuotesEvent event,
    Emitter<QuotesState> emit,
  ) async {
    try {
      emit(QuotesLoadingState());
      final url = Uri.parse(ApiService.getAllQuotes);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body)['quotes'] as List;
        quotes = jsonResponse.map((e) => QuoteModel.formJson(e)).toList();
        emit(QuotesLoadedState(quotes: quotes));
      } else {
        emit(QuotesFailureState('Failed to laod quotes', quotes: []));
      }
    } catch (e) {
      emit(QuotesFailureState('Failed to laod quotes $e', quotes: []));
    }
  }

  //pagination
  void _getAllQuotesByPagination(
    GetAllQuotesByPaginationEvent event,
    Emitter<QuotesState> emit,
  ) async {
    if (isLoading || !hasMore) return;

    try {
      isLoading = true;

      if (skip == 0) {
        emit(QuotesLoadingState());
      }

      final url = Uri.parse(ApiService.getAllQuotesPagination(skip));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final apiResponse = jsonDecode(response.body)['quotes'] as List;
        final newQuotes = apiResponse
            .map((e) => QuoteModel.formJson(e))
            .toList();

        if (newQuotes.length < limit) {
          hasMore = false;
        }

        paginationQuotes.addAll(newQuotes);
        skip += newQuotes.length;
        // skip += limit;

        emit(QuotesLoadedState(quotes: List.from(paginationQuotes)));
      }
    } catch (e) {
      emit(QuotesFailureState(e.toString(), quotes: []));
    } finally {
      isLoading = false;
    }
  }

  //search
  void _searchQuotesEvent(
    SearchQuotesEvent event,
    Emitter<QuotesState> emit,
  ) async {
    //
    final q = event.query.trim().toLowerCase();
    //
    if (q.length < 3) {
      emit(QuotesLoadedState(quotes: quotes));
    }

    var searchResults = quotes.where((e) {
      final quote = e.quote.toLowerCase();
      final author = e.author.toLowerCase();
      return quote.contains(q) || author.contains(q);
    }).toList();

    if (searchResults.isEmpty) {
      emit(QuotesSearchNotFound());
    } else {
      emit(QuotesSearchState(quotes: searchResults));
    }
  }

  //saveQuotes
  void _saveRemoveQuotesEvent(
    SaveRemoveQuotesEvent event,
    Emitter<QuotesState> emit,
  ) async {
    try {
      final quote = event.quote;
      final savedQuotes = Utils.getSavedQuotes();
      bool isAlreadySaved = savedQuotes.any((e) => e.id == quote.id);
      final allQuotes = state.quotes;

      if (isAlreadySaved) {
        savedQuotes.removeWhere((e) => e.id == quote.id);
        await Utils.saveQuotes(savedQuotes);
        // log(jsonEncode(Utils.getSavedQuotes().map((e) => e.toJson()).toList()));
        emit(QuotesRemovedState(quotes: List.from(allQuotes)));
      } else {
        savedQuotes.add(quote);
        await Utils.saveQuotes(savedQuotes);
        // log(jsonEncode(Utils.getSavedQuotes().map((e) => e.toJson()).toList()));
        emit(QuotesSavedState(quotes: List.from(allQuotes)));
      }
    } catch (e) {
      log('Error while saving removing quotes $e');
    }
  }

  //shareQuotes
  void _shareQuoteEvent(
    ShareQuoteEvent event,
    Emitter<QuotesState> emit,
  ) async {
    final key = event.globalKey;
    //wait till the frame is fully painted
    await WidgetsBinding.instance.endOfFrame;
    //find the widget to take a picture of by globalkey
    final boundry =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    //take the screenshot of the widget
    final image = await boundry.toImage(pixelRatio: 3.0);
    //turn the image into pnyByte
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    //get the rawData form the image
    final pngByte = byteData!.buffer.asUint8List();
    //find the place to save the image
    final directory = await getTemporaryDirectory();
    //decide the filapath
    final filePath = '${directory.path}/quotes.png';
    //save the file
    final file = File(filePath);
    file.writeAsBytes(pngByte);
    //share the image
    SharePlus.instance.share(
      ShareParams(files: [XFile(filePath)], text: 'Check out this quote !!'),
    );
  }

  //load favotires quotes
  void _loadFavoriteQuotes(
    GetFavotireQuotesEvent event,
    Emitter<QuotesState> emit,
  ) {
    try {
      favoriteQuotes = Utils.getSavedQuotes();
      emit(QuotesLoadedState(quotes: List.from(favoriteQuotes)));
    } catch (e) {
      log('error while loading saved quotes $e');
      emit(QuotesFailureState(e.toString()));
    }
  }
}

//bloc debouce method
EventTransformer<T> debouce<T>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

// switchMap says:
// ❌ Cancel "h"
// ❌ Cancel "he"
// ✅ Only keep "hel"

// So UI always shows latest result only.
