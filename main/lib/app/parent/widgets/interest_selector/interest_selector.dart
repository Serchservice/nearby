import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

part 'interest_selector_state.dart';

class InterestSelector extends StatefulWidget {
  final List<GoInterest> interests;
  final List<GoInterest> selected;
  final List<GoInterestCategory> categories;
  final bool isMultipleAllowed;
  final bool isLoading;
  final Color? buttonColor;
  final String? buttonText;
  final bool isScrollable;
  final GoInterestListener? goInterestListener;

  const InterestSelector({
    super.key,
    this.interests = const [],
    this.selected = const [],
    this.isMultipleAllowed = false,
    this.goInterestListener,
    this.categories = const [],
    this.isLoading = false,
    this.buttonColor,
    this.buttonText,
    this.isScrollable = false
  });

  @override
  State<InterestSelector> createState() => _InterestSelectorState();
}

class _InterestSelectorState extends State<InterestSelector> {
  List<GoInterest> _selected = [];
  List<GoInterest> _interests = [];
  List<GoInterestCategory> _categories = [];
  bool _isLoading = false;

  GoInterestCategory? _current;

  @override
  void initState() {
    _initSelectedInterests();

    super.initState();
  }

  void _initSelectedInterests() {
    List<GoInterestCategory> categories = widget.categories.where((GoInterestCategory category) => category.interests.isNotEmpty)
        .toSet()
        .toList();

    setState(() {
      _isLoading = widget.isLoading;
      _interests = widget.interests;
      _selected = widget.selected;
      _categories = categories;

      if(categories.isNotEmpty) {
        _current = _categories.first;
      }
    });
  }

  @override
  void didUpdateWidget(covariant InterestSelector oldWidget) {
    if(oldWidget.interests.length.notEquals(widget.interests.length) || oldWidget.interests.notEquals(widget.interests)) {
      _initSelectedInterests();
    }

    if(oldWidget.categories.length.notEquals(widget.categories.length) || oldWidget.categories.notEquals(widget.categories)) {
      _initSelectedInterests();
    }

    if(oldWidget.selected.length.notEquals(widget.selected.length) || oldWidget.selected.notEquals(widget.selected)) {
      _initSelectedInterests();
    }

    if(oldWidget.isLoading.notEquals(widget.isLoading)) {
      _initSelectedInterests();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _initSelectedInterests();

    super.didChangeDependencies();
  }

  @protected
  bool get useMany => widget.isMultipleAllowed;

  @protected
  GoInterestListener get onListening => widget.goInterestListener ?? (interests) {
    console.log("This is the list of selected interests", from: "[INTEREST SELECTOR]");

    for (var interest in interests) {
      console.log(interest, from: "[INTEREST SELECTOR]");
    }
  };

  void _handleCategorySelection(GoInterestCategory view) {
    setState(() {
      _current = view;
    });
  }

  void _handleInterestSelection(GoInterest interest) {
    if(useMany) {
      console.log(_selected);
      List<GoInterest> list = List.from(_selected);
      int index = list.findIndex((i) => i.id.equals(interest.id));

      if(index.equals(-1)) {
        list.add(interest);
      } else {
        list.removeAt(index);
      }

      onListening(list);
    } else {
      onListening([interest]);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingChild = Wrap(
      runAlignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: 20.listGenerator.map((index) {
        return LoadingShimmer(
          isDarkMode: Database.instance.isDarkTheme,
          darkHighlightColor: CommonColors.instance.shimmerHigh.darken(66),
          darkBaseColor: CommonColors.instance.shimmerHigh.darken(65),
          content: Container(
            padding: EdgeInsets.all(12),
            width: 100 + (index % 3) * 30.0,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CommonColors.instance.shimmer
            ),
          ),
        );
      }).toList(),
    );

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(_isLoading) ...[
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 35,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (context, index) {
                return Spacing.horizontal(10);
              },
              itemBuilder: (context, index) {
                return LoadingShimmer(
                  isDarkMode: Database.instance.isDarkTheme,
                  darkHighlightColor: CommonColors.instance.shimmerHigh.darken(66),
                  darkBaseColor: CommonColors.instance.shimmerHigh.darken(65),
                  content: Container(
                    padding: EdgeInsets.all(12),
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: CommonColors.instance.shimmer
                    ),
                  ),
                );
              },
            ),
          ),
          if(widget.isScrollable) ...[
            SingleChildScrollView(child: loadingChild)
          ] else ...[
            loadingChild
          ]
        ] else if(_interests.isNotEmpty) ...[
          _interestList(_interests),
        ] else if(_categories.isNotEmpty) ...[
          _tabs(),
          if(_current.isNotNull) ...[
            if(_current!.interests.isNotEmpty) ...[
              _interestList(_current!.interests)
            ] else ...[
              Expanded(child: PagingNoItemFoundIndicator(message: "No interests found", icon: Icons.search))
            ]
          ] else ...[
            Expanded(child: PagingNoItemFoundIndicator(message: "Select a category", icon: Icons.category))
          ]
        ] else ...[
          Expanded(child: PagingNoItemFoundIndicator(message: "No interests found", icon: Icons.search))
        ]
      ],
    );
  }

  Widget _tabs() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 35,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) {
          return Spacing.horizontal(10);
        },
        itemBuilder: (context, index) {
          GoInterestCategory category = _categories[index];
          final bool isSelected = _current.isNotNull && (category.equals(_current!) || category.id.equals(_current!.id));

          final Color baseColor = CommonColors.instance.bluish;
          final Color bgColor = isSelected ? baseColor.lighten(45) : baseColor.lighten(90);
          final Color txtColor = isSelected ? baseColor : baseColor.lighten(30);

          return TextButton(
            onPressed: () => _handleCategorySelection(category),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) => bgColor),
              overlayColor: WidgetStateProperty.resolveWith((states) {
                return baseColor.lighten(60);
              }),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: WidgetStateProperty.resolveWith((state) => Size(50, 30)),
            ),
            child: TextBuilder(
              text: category.name,
              size: Sizing.font(11),
              color: txtColor,
            )
          );
        },
      ),
    );
  }

  Widget _interestList(List<GoInterest> interests) {
    Widget child = Wrap(
      runAlignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: interests.map((interest) {
        return InterestViewer(
          interest: interest,
          buttonColor: widget.buttonColor,
          buttonText: widget.buttonText,
          // color: CommonColors.instance.darkTheme2,
          isSelected: _selected.contains(interest),
          onClick: () => _handleInterestSelection(interest),
        );
      }).toList(),
    );

    if(widget.isScrollable) {
      return SingleChildScrollView(child: child);
    } else {
      return child;
    }
  }
}