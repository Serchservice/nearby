import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart' show BoolExtensions, DynamicExtensions, FakeField, GoBack, IntExtensions, InteractiveButton, IterableExtension, ModalBottomSheet, ModalBottomSheetIndicator, Sizing, Spacing, TextBuilder, UiConfig;

import 'widgets/search_step.dart';

class NearbyPlaceSearch extends StatefulWidget {
  final bool useCurrentLocation;
  final Address? currentLocation;

  const NearbyPlaceSearch({super.key, required this.useCurrentLocation, this.currentLocation});

  static void open({required bool useCurrentLocation, Address? currentLocation}) {
    Navigate.bottomSheet(
      sheet: NearbyPlaceSearch(useCurrentLocation: useCurrentLocation, currentLocation: currentLocation),
      route: Navigate.appendRoute("/search-nearby"),
      isScrollable: true
    );
  }

  @override
  State<NearbyPlaceSearch> createState() => _NearbyPlaceSearchState();
}

class _NearbyPlaceSearchState extends State<NearbyPlaceSearch> {
  Address? _address;
  Category? _category;
  CategorySection _section = CategorySection.empty();

  @override
  void initState() {
    _address = widget.useCurrentLocation ? widget.currentLocation : ParentController.data.state.selectedAddress.value;
    _category = ParentController.data.category;
    _section = ParentController.data.state.category.value;

    super.initState();
  }

  List<FakeField> get fields => [
    if(widget.useCurrentLocation.isFalse) ...[
      FakeField(
        onTap: () => ParentController.data.handleLocationSearch(onReceived: (Address address) {
          setState(() {
            _address = address;
          });
        }),
        searchText: "Where is your starting point?",
        buttonText: "Search",
        padding: EdgeInsets.only(left: 6),
      )
    ],
    FakeField(
      onTap: () => ParentController.data.handleCategorySearch(_section, onReceived: (CategorySection section) {
        setState(() {
          _section = section;
          _category = category;
        });
      }),
      searchText: "What nearby place are you looking for?",
      showSearchButton: false,
      buttonText: "Around",
      padding: EdgeInsets.only(left: 6),
    )
  ];

  void clear() {
    setState(() {
      _section = CategorySection.empty();
      _address = null;
    });

    ParentController.data.clearSelection();
  }

  void search() {
    Navigate.close(closeAll: false);
    ParentController.data.search();
    clear();
  }

  Category? get category {
    return Category.categories.find((c) {
      return c.sections.any((s) => s.type == _section.type);
    });
  }

  String get location => widget.useCurrentLocation
    ? "You are using current location for your nearby search."
    : "You can hasten your search with your current location.";

  bool get hasCategory => (_category.isNotNull && _category!.title.isNotEmpty && _section.type.isNotEmpty);

  bool get hasDetails => hasCategory || (_address.isNotNull && _address!.hasAddress);

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: SingleChildScrollView(
        child: BannerAdLayout(
          expandChild: false,
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModalBottomSheetIndicator(showButton: false, margin: 0),
                  GoBack(onTap: () => Navigate.close(closeAll: false), size: 25),
                  Image.asset(
                    Assets.animGoBeyond,
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.sizeOf(context).width,
                    height: 200,
                  ),
                ],
              ),
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.logoFavicon,
                    width: 30,
                    height: 30,
                  ),
                  Expanded(
                    child: TextBuilder(
                      text: "Finding nearby places is now simplified for you and your friends.",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(13),
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 0,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: fields.asMap().entries.map((item) {
                      return SearchStep(
                        custom: item.value,
                        height: 38,
                        showBottom: item.key.equals(0),
                      );
                    }).toList()
                  ),
                ),
              ),
              NearbyPlaceSearchSelection(
                hasDetails: hasDetails,
                onCleared: clear,
                onSearch: search,
                canShowButton: false,
                title: _section.title,
                category: _category,
                address: _address,
              ),
              if(_address.isNotNull && _category.isNotNull) ...[
                Spacing.vertical(20),
                InteractiveButton(
                  text: "Search",
                  borderRadius: 24,
                  width: MediaQuery.sizeOf(context).width,
                  textSize: Sizing.font(14),
                  buttonColor: CommonColors.instance.color,
                  textColor: CommonColors.instance.lightTheme,
                  onClick: search,
                )
              ],
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CommonColors.instance.color,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: TextBuilder(
                  text: "$location Change this behaviour using the location icon in the `Activities` screen.",
                  color: CommonColors.instance.lightTheme,
                  size: Sizing.font(11),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}