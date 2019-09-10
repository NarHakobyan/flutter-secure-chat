import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:secure_chat/data/repositories/auth_repository.dart';
import 'package:secure_chat/models/user/user.dart';
import 'package:secure_chat/store/auth/auth_state.dart';
import 'package:secure_chat/store/data/data_state.dart';
import 'package:secure_chat/store/error/error_state.dart';
import 'package:secure_chat/utils/dio/dio_error_util.dart';

part 'register_state.g.dart';

// This is the class used by rest of your codebase
class RegisterState = _RegisterState with _$RegisterState;

// The store-class
abstract class _RegisterState with Store {

  final dataState = DataState();
  final errorState = ErrorState();
  final AuthRepository authRepository = GetIt.I<AuthRepository>();

  @observable
  bool rememberMe = false;

  // actions:-------------------------------------------------------------------
  @action
  Future<User> registerUser(Map<String, dynamic> data) async {
    dataState.startLoading();

    try {
      final user = await authRepository.registerUser(data);

      GetIt.I<AuthState>().setCurrentUser(user);

      errorState.error = null;
      return user;
    } on DioError catch (e) {
      errorState.error = DioErrorUtil.handleError(e);
    } finally {
      dataState
        ..dataFetched()
        ..stopLoading();
    }
  }
}