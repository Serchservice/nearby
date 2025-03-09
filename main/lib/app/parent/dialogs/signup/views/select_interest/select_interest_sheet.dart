import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetX;
import 'package:smart/smart.dart';

class SelectInterestSheet extends StatelessWidget {
  final String emailAddress;
  const SelectInterestSheet({super.key, required this.emailAddress});

  static void open(String emailAddress) {
    Navigate.bottomSheet(
      sheet: SelectInterestSheet(emailAddress: emailAddress),
      route: Navigate.appendRoute("/auth/complete"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: GetX<SelectInterestController>(
        init: SelectInterestController(emailAddress),
        builder: (controller) {
          bool isFetchingCategories = controller.state.isFetchingCategories.value;
          bool canPop = controller.state.canPop.value;

          return PopScope(
            canPop: canPop,
            child: BannerAdLayout(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GoBack(onTap: () => canPop ? {} : Navigate.back()),
                  TextBuilder(
                    text: "What are you interested in?",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(24),
                    weight: FontWeight.bold,
                  ),
                  TextBuilder(
                    text: "Tell us your interests so nearby can power your experience in the best way. Don't be shy!",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(14),
                  ),
                  Spacing.vertical(10),
                  Expanded(
                    child: InterestSelector(
                      isLoading: isFetchingCategories,
                      isMultipleAllowed: true,
                      isScrollable: true,
                      categories: controller.state.categories,
                      selected: controller.state.selected,
                      goInterestListener: (interests) {
                        controller.state.selected.value = interests;
                      },
                    ),
                  ),
                  if(controller.state.selected.isNotEmpty) ...[
                    Spacing.vertical(10),
                    InteractiveButton(
                      text: "Complete signup",
                      borderRadius: 24,
                      width: MediaQuery.sizeOf(context).width,
                      textSize: Sizing.font(14),
                      buttonColor: CommonColors.instance.color,
                      textColor: CommonColors.instance.lightTheme,
                      onClick: controller.register,
                      loading: controller.state.isLoading.value,
                    ),
                  ]
                ],
              ),
            ),
          );
        }
      )
    );
  }
}