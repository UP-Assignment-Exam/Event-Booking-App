import 'package:get/get.dart';
import '../views/home_view.dart';
import '../core/transitions/page_transitions.dart';
part 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      transition: Transition.noTransition,
      customTransition: SlideFromRightTransition(),
      transitionDuration: const Duration(milliseconds: 400),
    ),
    // Define additional pages here:
    // GetPage(name: Routes.details, page: () => const DetailsView(), …),
  ];
}
