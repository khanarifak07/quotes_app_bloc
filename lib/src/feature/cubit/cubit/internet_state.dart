part of 'internet_cubit.dart';

sealed class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object> get props => [];
}

final class InternetLoading extends InternetState {}

final class InternerConnectedState extends InternetState {
  final ConnectionType connectionType;
  const InternerConnectedState({required this.connectionType});
}

final class InternerDisconnectedState extends InternetState {}
