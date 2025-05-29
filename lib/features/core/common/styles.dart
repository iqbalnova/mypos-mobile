import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// Color Schemes
class AppColors {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF2C59E5);
  static const Color primaryVariantLight = Color(0xFF1843C3);
  static const Color secondaryLight = Color(0xFFFFE164);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color errorLight = Color(0xFFE53935);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF212121);
  static const Color onSurfaceLight = Color(0xFF424242);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF08225F);
  static const Color primaryVariantDark = Color(0xFF061132);
  static const Color secondaryDark = Color(0xFF8F7200);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onBackgroundDark = Color(0xFFEEEEEE);
  static const Color onSurfaceDark = Color(0xFFBDBDBD);

  // Common Colors
  static const Color red = Color(0xFFE75C62);
  static const Color yellow = Color(0xFFFFC319);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9C9C9C);
  static const Color darkGrey = Color(0xFF626262);
}

// Font Weights
class AppFontWeight {
  static FontWeight light = FontWeight.w300;
  static FontWeight regular = FontWeight.w400;
  static FontWeight medium = FontWeight.w500;
  static FontWeight semiBold = FontWeight.w600;
  static FontWeight bold = FontWeight.w700;
  static FontWeight extraBold = FontWeight.w800;
}

// App Theme Class
class AppTheme {
  // Light Theme
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primaryVariantLight,
        secondary: AppColors.secondaryLight,
        surface: AppColors.surfaceLight,
        error: AppColors.errorLight,
        onPrimary: AppColors.onPrimaryLight,
        onSurface: AppColors.onSurfaceLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.onPrimaryLight,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.onPrimaryLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryLight),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorLight, width: 1),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Dark Theme
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        primaryContainer: AppColors.primaryVariantDark,
        secondary: AppColors.secondaryDark,
        surface: AppColors.surfaceDark,
        error: AppColors.errorDark,
        onPrimary: AppColors.onPrimaryDark,
        onSurface: AppColors.onSurfaceDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.onPrimaryDark,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.onPrimaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.secondaryDark),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkGrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorDark, width: 1),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// Text Styles
class AppTextStyle {
  static TextStyle regularText({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.onBackgroundLight,
      fontSize: fontSize ?? 14.sp,
      fontWeight: fontWeight ?? AppFontWeight.regular,
    );
  }

  static TextStyle headline1({Color? color}) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.onBackgroundLight,
      fontSize: 26.sp,
      fontWeight: AppFontWeight.bold,
    );
  }

  static TextStyle headline2({Color? color}) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.onBackgroundLight,
      fontSize: 22.sp,
      fontWeight: AppFontWeight.bold,
    );
  }

  static TextStyle headline3({Color? color}) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.onBackgroundLight,
      fontSize: 18.sp,
      fontWeight: AppFontWeight.semiBold,
    );
  }

  static TextStyle subtitle1({Color? color}) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.onBackgroundLight,
      fontSize: 16.sp,
      fontWeight: AppFontWeight.semiBold,
    );
  }

  static TextStyle subtitle2({Color? color}) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.onBackgroundLight,
      fontSize: 14.sp,
      fontWeight: AppFontWeight.medium,
    );
  }

  static TextStyle bodyText1({Color? color}) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.onBackgroundLight,
      fontSize: 14.sp,
      fontWeight: AppFontWeight.regular,
    );
  }

  static TextStyle bodyText2({Color? color}) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.onBackgroundLight,
      fontSize: 12.sp,
      fontWeight: AppFontWeight.regular,
    );
  }

  static TextStyle button({Color? color}) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.onPrimaryLight,
      fontSize: 16.sp,
      fontWeight: AppFontWeight.semiBold,
    );
  }

  static TextStyle caption({Color? color}) {
    return GoogleFonts.poppins(
      color: color ?? AppColors.grey,
      fontSize: 12.sp,
      fontWeight: AppFontWeight.regular,
    );
  }

  static TextStyle error() {
    return GoogleFonts.poppins(
      color: AppColors.errorLight,
      fontSize: 12.sp,
      fontWeight: AppFontWeight.regular,
    );
  }
}
