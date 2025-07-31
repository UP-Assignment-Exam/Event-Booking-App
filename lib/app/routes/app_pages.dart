import 'package:get/get.dart';
import '../views/home_view.dart';
import '../views/pages/auth/signin_screen.dart';
import '../views/pages/auth/signup_screen.dart';
import '../views/pages/auth/forgot_password_screen.dart';
import '../views/pages/profile_page.dart';
import '../core/transitions/page_transitions.dart';
import '../bindings/auth_binding.dart';
part 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.signin,
      page: () => const SigninScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.signup,
      page: () => SignupScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.reset,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      transition: Transition.noTransition,
      customTransition: SlideFromRightTransition(),
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfilePage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    // Define additional pages here:
    // GetPage(name: Routes.eventList, page: () => const EventListView(), ...),
  ];
}
