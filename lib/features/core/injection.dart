import '../product/domain/usecases/add_products.dart';
import '../product/domain/usecases/delete_products.dart';
import '../product/domain/usecases/get_products.dart';
import '../product/domain/usecases/update_products.dart';

import '../auth/data/datasources/auth_remote_datasource.dart';
import '../auth/domain/repositories/auth_repository.dart';
import '../auth/domain/usecases/login_usecase.dart';
import '../auth/presentation/bloc/auth_bloc.dart';

import '../auth/data/repositories/auth_repository_impl.dart';
import '../product/data/datasources/product_remote_datasource.dart';
import '../product/data/repositories/product_repository_impl.dart';
import '../product/domain/repositories/product_repository.dart';
import '../product/domain/usecases/add_category.dart';
import '../product/domain/usecases/delete_category.dart';
import '../product/domain/usecases/get_categories.dart';
import '../product/domain/usecases/update_category.dart';
import '../product/presentation/bloc/product_bloc.dart';
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
  locator.registerFactory(
    () => ProductBloc(
      getCategories: locator(),
      addCategory: locator(),
      updateCategory: locator(),
      deleteCategory: locator(),
      getProducts: locator(),
      addProduct: locator(),
      updateProduct: locator(),
      deleteProduct: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => GetCategories(locator()));
  locator.registerLazySingleton(() => AddCategory(locator()));
  locator.registerLazySingleton(() => UpdateCategory(locator()));
  locator.registerLazySingleton(() => DeleteCategory(locator()));

  locator.registerLazySingleton(() => GetProducts(locator()));
  locator.registerLazySingleton(() => AddProduct(locator()));
  locator.registerLazySingleton(() => UpdateProduct(locator()));
  locator.registerLazySingleton(() => DeleteProduct(locator()));

  // repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: locator()),
  );

  // data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      client: locator(),
      secureStorageHelper: locator(),
    ),
  );
}
