import '../auth/data/datasources/auth_remote_datasource.dart';
import '../auth/domain/repositories/auth_repository.dart';
import '../auth/domain/usecases/login_usecase.dart';
import '../auth/presentation/bloc/auth_bloc.dart';

import '../auth/data/repositories/auth_repository_impl.dart';
import 'helper/secure_storage_helper.dart';
import 'router/app_router.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

Future<void> init() async {
  // Register Core Services
  locator.registerSingleton<AppRouter>(AppRouter());

  // External
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => SecureStorageHelper());

  // BLoC
  locator.registerFactory(() => AuthBloc(loginUseCase: locator()));

  // use case
  locator.registerLazySingleton(() => LoginUseCase(locator()));

  // repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: locator()),
  );

  // data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: locator()),
  );
}
