import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

class AppTextTheme {
  AppTextTheme._();

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: AppAssets.fontHead,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontFamily: AppAssets.fontHead,
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.15,
    ),
    displaySmall: TextStyle(
      fontFamily: AppAssets.fontHead,
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),
    headlineLarge: TextStyle(
      fontFamily: AppAssets.fontHead,
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppAssets.fontHead,
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.28,
    ),
    headlineSmall: TextStyle(
      fontFamily: AppAssets.fontHead,
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
    ),
    titleLarge: TextStyle(
      fontFamily: AppAssets.fontHead,
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontFamily: AppAssets.fontHead,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    titleSmall: TextStyle(
      fontFamily: AppAssets.fontBody,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.4,
    ),
    bodyLarge: TextStyle(
      fontFamily: AppAssets.fontBody,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppAssets.fontBody,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.42,
    ),
    bodySmall: TextStyle(
      fontFamily: AppAssets.fontBody,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
    labelLarge: TextStyle(
      fontFamily: AppAssets.fontHead,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.42,
    ),
    labelMedium: TextStyle(
      fontFamily: AppAssets.fontBody,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontFamily: AppAssets.fontBody,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );
}


/// use case

//     Text(
//       'Water the plants 🌿',
//       style: Theme.of(context).textTheme.bodyLarge,
//     )
//
// // Custom Usage for your "Red Underline" scenario
//     Text(
//     'Task Overdue!',
//     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//       color: Colors.red,
//       decoration: TextDecoration.underline,
//       decorationColor: Colors.red,
//     ),
//   )

// Category -- Widget Examples -- Recommended Style -- Font Used
// App Navigation -- "AppBar Title --  SliverAppBar" -- headlineSmall -- Satoshi
// Page Headers -- Large Page Titles (Splash/Onboarding) -- headlineLarge -- Satoshi
// List Items -- "ListTile title --  Card Heading" -- titleMedium -- Plus Jakarta Sans
// Descriptions -- "ListTile subtitle --  Paragraphs" -- bodyMedium -- Plus Jakarta Sans
// User Input -- "TextField input text --  TextFormField" -- bodyLarge -- Plus Jakarta Sans
// Input Decoration -- "TextField hint text --  Helper text" -- bodyMedium -- Plus Jakarta Sans
// Buttons -- "ElevatedButton --  TextButton --  OutlinedButton" -- labelLarge -- Satoshi
// Dialogs -- AlertDialog Title -- titleLarge -- Plus Jakarta Sans
// Gantt Chart -- "Time labels (08:00) --  Date indicators" -- labelSmall -- Plus Jakarta Sans
// Tags/Chips -- "Category tags (e.g. --  ""Health"" --  ""Work"")" -- labelMedium -- Plus Jakarta Sans
