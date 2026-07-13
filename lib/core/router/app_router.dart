import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/auth/presentation/view_models/current_user_provider.dart';
import 'package:narrata/features/auth/presentation/view_models/phone_verification_state.dart';
import 'package:narrata/features/auth/presentation/views/login_page.dart';
import 'package:narrata/features/auth/presentation/views/phone_auth_page.dart';
import 'package:narrata/features/auth/presentation/views/otp_auth_page.dart';
import 'package:narrata/features/auth/presentation/views/signup_page.dart';
import 'package:narrata/features/home/presentation/views/home_page.dart';
import 'package:narrata/features/splash/presentation/views/splash_page.dart';
import 'package:narrata/features/onboarding/presentation/views/story_selection_page.dart';
import 'package:narrata/features/auth/presentation/views/walkthrough_page.dart';
import 'package:narrata/features/library/presentation/views/library_page.dart';
import 'package:narrata/features/favorites/presentation/views/favorites_page.dart';
import 'package:narrata/features/profile/presentation/views/profile_screen.dart';
import 'package:narrata/features/profile/presentation/views/setup_profile_page.dart';
import 'package:narrata/core/widgets/main_scaffold.dart';

import 'package:narrata/features/stories/presentation/views/story_read_page.dart';
import 'package:narrata/features/stories/domain/models/story.dart';

part 'app_router.g.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(currentUserProvider, (previous, next) => notifyListeners());
    _ref.listen(
      phoneVerificationStateProvider,
      (previous, next) => notifyListeners(),
    );
  }
}

@riverpod
GoRouter appRouter(Ref ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final currentUserState = ref.read(currentUserProvider);

      // If auth state is still loading, keep showing the splash screen
      if (currentUserState.isLoading || currentUserState.hasError) {
        return null; // Stay where you are (which is '/' initially)
      }

      final userModel = currentUserState.value;
      final isAuth = userModel != null;
      final isOnboardingCompleted = userModel?.isOnboardingCompleted ?? false;

      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/phone-auth' ||
          state.matchedLocation == '/phone-auth/otp-auth';

      final isSplashRoute = state.matchedLocation == '/';
      final isFirebaseAuthDeepLink =
          state.matchedLocation.startsWith('/firebaseauth') ||
          state.uri.host == 'firebaseauth' ||
          state.matchedLocation == '/link' ||
          state.matchedLocation == '/__'; // Web fallback sometimes uses /__

      // Check if we have pending phone verification data (set by the ViewModel)
      final pendingVerification = ref.read(phoneVerificationStateProvider);

      if (isFirebaseAuthDeepLink) {
        // If Firebase deep link AND we have verification data, go to OTP screen
        if (pendingVerification != null) {
          return '/phone-auth/otp-auth';
        }
        return null;
      }

      if (isSplashRoute) {
        return null; // SplashPage manages its own exit navigation after the animation
      }

      if (isAuthRoute) {
        if (isAuth) {
          return isOnboardingCompleted ? '/home' : '/onboarding';
        }
        return null; // If trying to access auth unauthenticated, stay.
      }

      if (!isAuth) {
        if (isAuthRoute || state.matchedLocation == '/walkthrough') {
          return null;
        }
        return '/walkthrough'; // Default destination for unauthenticated users
      }
      
      // If auth is valid, check if name is empty (new phone auth user)
      if (isAuth && userModel.fullName.isEmpty && state.matchedLocation != '/setup-profile') {
        return '/setup-profile';
      }

      // If they are on setup-profile but already have a name, kick them to onboarding or home
      if (isAuth && userModel.fullName.isNotEmpty && state.matchedLocation == '/setup-profile') {
        return isOnboardingCompleted ? '/home' : '/onboarding';
      }
      
      if (isAuth && !isOnboardingCompleted && state.matchedLocation != '/onboarding' && state.matchedLocation != '/setup-profile') {
        return '/onboarding'; // Authenticated but onboarding incomplete
      }

      if (isAuth && isOnboardingCompleted && state.matchedLocation == '/onboarding') {
        return '/home'; // Already completed onboarding
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
        routes: [
          GoRoute(
            path: 'otp-auth',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final pending = ref.read(phoneVerificationStateProvider);
              return OtpAuthPage(
                verificationId:
                    (extra?['verificationId'] as String?) ??
                    pending?.verificationId ??
                    '',
                phoneNumber:
                    (extra?['phoneNumber'] as String?) ??
                    pending?.phoneNumber ??
                    '',
              );
            },
          ),
        ],
      ),
      // Dummy routes for Firebase deep links (reCAPTCHA fallback)
      GoRoute(
        path: '/firebaseauth/link',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/link',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/__',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: '/onboarding', builder: (context, state) => const StorySelectionPage()),
      GoRoute(path: '/walkthrough', builder: (context, state) => const WalkthroughPage()),
      GoRoute(path: '/setup-profile', builder: (context, state) => const SetupProfilePage()),
      GoRoute(
        path: '/story-read',
        builder: (context, state) {
          final story = state.extra as Story;
          return StoryReadPage(story: story);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profiles',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
