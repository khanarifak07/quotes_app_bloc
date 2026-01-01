import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app_bloc/src/feature/quotes/model/quote_model.dart';

abstract class QuotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllQuotesEvent extends QuotesEvent {}

class GetAllQuotesByPaginationEvent extends QuotesEvent {}

class GetFavotireQuotesEvent extends QuotesEvent {}

class SearchQuotesEvent extends QuotesEvent {
  final String query;
  SearchQuotesEvent(this.query);
}

class SaveRemoveQuotesEvent extends QuotesEvent {
  final QuoteModel quote;
  SaveRemoveQuotesEvent(this.quote);

  @override
  List<Object?> get props => [];
}

class ShareQuoteEvent extends QuotesEvent {
  final GlobalKey globalKey;
  ShareQuoteEvent({required this.globalKey});

  @override
  List<Object?> get props => [globalKey];
}
