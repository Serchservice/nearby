import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart' show StringExtensions;

import 'category_search_state.dart';

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
          .expand((Category category) => category.sections)
          .where((CategorySection section) => section.title.containsIgnoreCase(query) || section.type.containsIgnoreCase(query))
          .toList();
    } else {
      state.filtered.value = [];
    }
  }

  void handleSelect(CategorySection section) {
    Navigate.back(result: section);
  }
}