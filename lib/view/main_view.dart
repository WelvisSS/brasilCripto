import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/colors/colors.dart';
import '../view_models/controllers/home/home_view_model.dart';
import 'favorite_view.dart';
import 'home_view.dart';
import 'search_view.dart';

class MainScreen extends StatelessWidget {
  final controller = Get.find<HomeController>();

  final List<Widget> _pages = const [
    HomeView(key: ValueKey("HomeView")),
    SearchView(key: ValueKey("SearchView")),
    FavoriteView(key: ValueKey("FavoriteView")),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "BrasilCripto",
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder:
              (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
          child: _pages[controller.selectedIndex.value],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.black,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            controller.selectedIndex.value = index;
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bar_chart,
                color:
                    controller.selectedIndex.value == 0
                        ? AppColors.primary
                        : AppColors.gray,
              ),
              label: 'Mercado',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color:
                    controller.selectedIndex.value == 1
                        ? AppColors.primary
                        : AppColors.gray,
              ),
              label: 'Pesquisar',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                color:
                    controller.selectedIndex.value == 2
                        ? AppColors.primary
                        : AppColors.gray,
              ),
              label: 'Favoritos',
            ),
          ],
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.gray,
        ),
      );
    });
  }
}
