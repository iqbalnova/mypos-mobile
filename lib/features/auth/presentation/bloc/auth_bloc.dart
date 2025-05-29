import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/helper/secure_storage_helper.dart';
import '../../../core/injection.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SecureStorageHelper _secureStorageHelper =
      locator<SecureStorageHelper>();

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await loginUseCase.execute(event.email, event.password);

      if (result.isLeft()) {
        final failure = result.fold((l) => l, (r) => null)!;
        emit(AuthFailure(failure.message));
      } else {
        final user = result.fold((l) => null, (r) => r)!;
        await _secureStorageHelper.saveToken(user.token);
        await _secureStorageHelper.saveUserCredential(
          email: user.email,
          name: user.name,
        );
        emit(AuthSuccess(user));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
