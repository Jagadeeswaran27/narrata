import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:narrata/features/auth/presentation/views/login_page.dart';
import 'package:narrata/features/auth/presentation/views/phone_auth_page.dart';
import 'package:narrata/features/auth/presentation/views/signup_page.dart';
import 'package:narrata/features/home/presentation/views/home_page.dart';
import 'package:narrata/features/splash/presentation/views/splash_page.dart';

part 'app_router.g.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (previous, next) => notifyListeners());
  }
}

@riverpod
GoRouter appRouter(Ref ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);

      // If auth state is still loading, keep showing the splash screen
      if (authState.isLoading || authState.hasError) {
        return null; // Stay where you are (which is '/' initially)
      }

      final isAuth = authState.value != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/phone-auth';

      final isSplashRoute = state.matchedLocation == '/';

      if (isSplashRoute) {
        return isAuth ? '/home' : '/login';
      }

      if (isAuthRoute) {
        return isAuth
            ? '/home'
            : null; // If authenticated, move to home. Otherwise stay.
      }

      if (!isAuth) {
        return '/login'; // If trying to access a protected route unauthenticated
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
      GoRoute(
        path: '/phone-auth',
        builder: (context, state) => const PhoneAuthPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
  );
}
