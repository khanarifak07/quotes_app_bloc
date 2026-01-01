import 'package:equatable/equatable.dart';
import 'package:quotes_app_bloc/src/feature/quotes/model/quote_model.dart';

abstract interface class QuotesState extends Equatable {
  final List<QuoteModel> quotes;

  const QuotesState({required this.quotes});

  @override
  List<Object?> get props => [quotes];
}

class QuotesInitialState extends QuotesState {
  const QuotesInitialState({super.quotes = const []});
}

class QuotesLoadingState extends QuotesState {
  const QuotesLoadingState({super.quotes = const []});
}

class QuotesLoadedState extends QuotesState {
  const QuotesLoadedState({required super.quotes});

  @override
  List<Object?> get props => [quotes, identityHashCode(this)];
}

class QuotesSearchState extends QuotesState {
  const QuotesSearchState({required super.quotes});

  @override
  List<Object?> get props => [quotes, identityHashCode(this)];
}

class QuotesSearchNotFound extends QuotesState {
  const QuotesSearchNotFound({super.quotes = const []});
}

class QuotesSavedState extends QuotesState {
  const QuotesSavedState({required super.quotes});
  @override
  List<Object?> get props => [quotes, identityHashCode(this)];
}

class QuotesRemovedState extends QuotesState {
  const QuotesRemovedState({required super.quotes});
  @override
  List<Object?> get props => [quotes, identityHashCode(this)];
}

class QuotesFailureState extends QuotesState {
  final String message;
  const QuotesFailureState(this.message, {super.quotes = const []});

  @override
  List<Object?> get props => [message];
}
