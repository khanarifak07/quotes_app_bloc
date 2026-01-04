import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app_bloc/src/common/enums.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription? subscription;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    _init();
  }

  Future<void> _init() async {
    // 1️⃣ Get initial connectivity
    final result = await connectivity.checkConnectivity();
    _emitResult(result);

    // 2️⃣ Listen to changes
    subscription = connectivity.onConnectivityChanged.listen(_emitResult);
  }

  void _emitResult(List<ConnectivityResult> results) async {
    final result = results.last;
    if (result == ConnectivityResult.wifi) {
      emit(InternerConnectedState(connectionType: ConnectionType.wifi));
    } else if (result == ConnectivityResult.mobile) {
      emit(InternerConnectedState(connectionType: ConnectionType.mobile));
    } else if (result == ConnectivityResult.none) {
      emit(InternerDisconnectedState());
    } else {}
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
