import 'package:drive/library.dart';
import 'package:flutter/material.dart' show TabController;
import 'package:get/get.dart';
import 'package:smart/smart.dart' show ButtonView, IterableExtension, TExtensions;

import 'go_interest_state.dart';

class GoInterestController extends GetxController with GetTickerProviderStateMixin {
  GoInterestController();
  final state = GoInterestState();

  final ConnectService _connect = Connect();
  final LocationService _locationService = LocationImplementation();

  late TabController tabController;

  List<ButtonView> tabs = [
    ButtonView(header: "Mine"),
    ButtonView(header: "Others"),
  ];

  @override
  void onInit() {
    tabController = TabController(
      length: tabs.length,
      initialIndex: state.current.value,
      vsync: this
    );

    _locationService.getAddress(
      onSuccess: (address, position) {
        state.address.value = address;
      },
      onError: (error) {
        state.address.value = Database.instance.address;
      }
    );

    super.onInit();
  }

  @override
  void onReady() {
    _handleChanges();
    _loadCategories();

    tabController.addListener(() {
      updateCurrent(tabController.index);
    });

    super.onReady();
  }

  void _handleChanges() {
    List<GoInterestCategory> categories = Database.instance.interestCategories;
    List<GoInterestCategory> uniqueCategories = List.from([]);

    for (GoInterestCategory category in categories) {
      if (!uniqueCategories.any((uniqueCategory) =>
      uniqueCategory.id == category.id)) {
        uniqueCategories.add(category);
      }
    }

    for (GoInterestCategory category in uniqueCategories) {
      List<GoInterest> uniqueInterests = List.from([]);

      for (GoInterest interest in category.interests) {
        if (!uniqueInterests.any((uniqueInterest) => uniqueInterest.id == interest.id)) {
          uniqueInterests.add(interest);
        }
      }
      category.interests.clear();
      category.interests.addAll(uniqueInterests);
    }

    state.goCategories.value = uniqueCategories;
  }

  void _loadCategories() {
    state.isFetchingCategories.value = true;

    _connect.get(endpoint: "/go/interest/update").then((Outcome response) {
      state.isFetchingCategories.value = false;

      if(response.isSuccessful) {
        _update(GoInterestUpdate.fromJson(response.data));
      } else {
        notify.error(message: response.message);
      }
    });
  }

  bool get isAdd => state.selected.value.isNotEmpty && state.current.value.equals(1);

  int get count => isAdd ? state.selected.value.length : state.removal.value.length;

  bool get isRemove => state.removal.value.isNotEmpty && state.current.value.equals(0);

  bool get showButton => isAdd || isRemove;

  String get buttonText => state.current.value.equals(1) ? "Update" : "Delete";

  void updateCurrent(int index) {
    state.current.value = index;
    tabController.index= index;
  }

  void process() {
    if(state.current.value.equals(1)) {
      _upload();
    } else {
      _delete();
    }
  }

  void _upload() async {
    state.isSaving.value = true;

    Set<int> ids = state.selected.value.map((GoInterest interest) => interest.id).toSet();

    _connect.post(endpoint: "/go/interest", body: {"interests": ids.toList()}).then((Outcome response) {
      if (response.isSuccessful) {
        state.selected.value = List.empty();
        _update(GoInterestUpdate.fromJson(response.data));
        updateCurrent(0);
        state.isSaving.value = false;
      } else {
        state.isSaving.value = false;
        notify.error(message: response.message);
      }
    });
  }

  void _delete() async {
    state.isSaving.value = true;

    Set<int> ids = state.removal.value.map((GoInterest interest) => interest.id).toSet();

    _connect.delete(endpoint: "/go/interest", body: {"interests": ids.toList()}).then((Outcome response) {
      if (response.isSuccessful) {
        state.removal.value = List.empty();
        _update(GoInterestUpdate.fromJson(response.data));
        updateCurrent(0);
        state.isSaving.value = false;
      } else {
        state.isSaving.value = false;
        notify.error(message: response.message);
      }
    });
  }

  void _update(GoInterestUpdate update) {
    List<GoInterest> interests = update.taken.flatMap<GoInterest>((GoInterestCategory e) => e.interests).toList();
    CentreController.data.state.interests.value = interests;
    Database.instance.saveInterests(interests);

    state.goCategories.value = update.taken;
    CentreController.data.state.categories.value = update.taken;
    Database.instance.saveInterestCategories(update.taken);

    state.categories.value = update.reserved;
  }
}