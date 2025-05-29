import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/presentation/pages/login_page.dart';
import '../../auth/presentation/pages/onboarding_page.dart';
import '../../product/presentation/bloc/product_bloc.dart';
import '../../product/presentation/pages/cart_page.dart';
import '../../product/presentation/pages/category_management.dart';
import '../../product/presentation/pages/list_product_page.dart';
import '../../product/presentation/pages/payment_success.dart';
import '../../product/presentation/pages/qris_payment_page.dart';
import '../injection.dart' as di;
import '../presentation/pages/coming_soon_page.dart';
import '../presentation/pages/main_screen.dart';
import '../presentation/pages/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case AppRoutes.splash:
        page = const SplashScreen();
        break;
      case AppRoutes.onboarding:
        page = const OnboardingPage();
        break;
      case AppRoutes.login:
        page = const LoginPage();
        break;
      case AppRoutes.main:
        final args = settings.arguments as Map<String, dynamic>?;
        final initialIndex = args?['initialIndex'] ?? 0;
        page = MainScreen(initialIndex: initialIndex);
        break;
      case AppRoutes.listProduct:
        page = ListProductPage(locator: di.locator);
        break;
      case AppRoutes.categoryManagement:
        page = BlocProvider(
          create: (context) => di.locator<ProductBloc>(),
          child: CategoryManagementPage(locator: di.locator),
        );
        break;
      case AppRoutes.cart:
        page = const CartPage();
        break;
      case AppRoutes.qrisPayment:
        page = const QrisPaymentPage();
        break;
      case AppRoutes.paymentSuccess:
        page = const PaymentSuccess();
        break;
      case AppRoutes.comingSoon:
        page = const ComingSoonPage();
        break;
      default:
        page = const Scaffold(
          body: Center(
            child: Text(
              'Page not found :(',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
          ),
        );
    }

    // List route yang ingin memakai animasi slide
    final animatedRoutes = {AppRoutes.listProduct, AppRoutes.cart};

    // Gunakan animasi hanya untuk route tertentu
    if (animatedRoutes.contains(settings.name)) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    }

    // Default: tanpa animasi khusus
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}
