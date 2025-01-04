import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySearchController extends GetxController {
  CategorySearchController();
  final state = CategorySearchState();

  final TextEditingController searchController = TextEditingController();

  final args = Get.arguments;

  @override
  void onInit() {
    if(args != null) {
      state.selected.value = args;
    }

    super.onInit();
  }

  @override
  void onReady() {
    searchController.addListener(_handleSearch);

    super.onReady();
  }

  void _handleSearch() {
    if (searchController.text.isNotEmpty) {
      String query = searchController.text.toLowerCase();

      state.filtered.value = Category.categories
        .expand((category) => category.sections)
        .where((section) {
          return section.title.toLowerCase().contains(query) || section.type.toLowerCase().contains(query);
        }).toList();
    } else {
      state.filtered.value = [];
    }
  }

  void handleSelect(CategorySection section) {
    Navigate.back(result: section);
  }
}