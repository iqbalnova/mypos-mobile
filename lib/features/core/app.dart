import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common/styles.dart';
import 'router/app_router.dart';
import 'package:get_it/get_it.dart';

import 'common/utils.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: !kDebugMode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          navigatorObservers: [routeObserver],
          onGenerateRoute: GetIt.instance<AppRouter>().onGenerateRoute,
        );
      },
    );
  }
}
