import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glauk/core/theme/theme.dart';
import 'package:glauk/routes/app_router.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        theme: appTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
