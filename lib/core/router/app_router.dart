import 'package:go_router/go_router.dart';

import 'package:narrata/features/auth/presentation/views/login_page.dart';
import 'package:narrata/features/auth/presentation/views/phone_auth_page.dart';
import 'package:narrata/features/auth/presentation/views/signup_page.dart';
import 'package:narrata/features/home/presentation/views/home_page.dart';
import 'package:narrata/features/splash/presentation/views/splash_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
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
