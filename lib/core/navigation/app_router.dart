import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/editor/presentation/screens/editor_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/editor',
        builder: (context, state) {
          final path = state.extra as String;
          return EditorScreen(imagePath: path);
        },
      ),
    ],
  );
}
