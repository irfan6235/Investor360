import 'package:get/get.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/routes/routes.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class CustomDrawerController extends GetxController {
  var selectedIndex = 0.obs;
  final DashboardController dashboardController =
      Get.put(DashboardController());
  late AdvancedDrawerController advancedDrawerController;

  @override
  void onInit() {
    selectedIndex.value = 10;
    super.onInit();
  }

  void setDrawerController(AdvancedDrawerController controller) {
    advancedDrawerController = controller;
  }

  void navigateToIndex(int index) {
    selectedIndex.value = index;
    advancedDrawerController.hideDrawer();
    switch (index) {
      case 0:
        Get.toNamed(Routes.account.name);
        break;
      case 1:
        Get.toNamed(Routes.portfolio.name);
        break;
      case 2:
        Get.toNamed(Routes.services.name);
        break;
      case 3:
        Get.toNamed(Routes.changempin.name);
        break;
      case 4:
        Get.toNamed(Routes.termsofuse.name);
        break;
      case 5:
        Get.toNamed(Routes.invite.name);
        break;
      case 6:
        Get.toNamed(Routes.support.name);
        break;
      case 7:
        //  dashboardController.logoutApi();
        break;
      default:
        break;
    }
  }

  void resetDrawerState() {
    selectedIndex.value = -1;
  }
}

final customDrawerController = CustomDrawerController();
