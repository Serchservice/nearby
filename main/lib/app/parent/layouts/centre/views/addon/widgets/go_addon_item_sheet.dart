import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

import 'go_addon_plan_item.dart';

class GoAddonItemSheet extends StatefulWidget {
  final GoAddon addon;
  const GoAddonItemSheet({super.key, required this.addon});

  static void open(GoAddon addon) {
    Navigate.bottomSheet(
      sheet: GoAddonItemSheet(addon: addon),
      isScrollable: true,
      route: Navigate.appendRoute("/${addon.id}")
    );
  }

  @override
  State<GoAddonItemSheet> createState() => _GoAddonItemSheetState();
}

class _GoAddonItemSheetState extends State<GoAddonItemSheet> {
  final ConnectService _connect = Connect();
  GoAddonPlan? _selected;
  bool _isSaving = false;

  void _register() async {
    if(_selected.isNotNull) {
      setState(() => _isSaving = true);
      Outcome response = await _connect.get(endpoint: "/go/addon/create?id=${_selected!.id}");
      setState(() => _isSaving = false);

      if(response.isSuccessful) {
        InitializePayment payment = InitializePayment.fromJson(response.data);
        Navigate.close(closeAll: false);

        await RouteNavigator.openWeb(
          header: "Continue with payment",
          url: payment.authorizationUrl,
          params: {"reference": payment.reference}
        );

        await VerifyTransaction.open(payment.reference);
        AddonController.data.fetchUserAddons();
        AddonController.data.fetchOtherAddons();
      } else {
        notify.error(message: response.message);
      }
    } else {
      notify.warn(message: "You need to select a plan to continue");
    }
  }

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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ModalBottomSheetIndicator(showButton: false, margin: 0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GoBack(onTap: () => Navigate.close(closeAll: false), size: 25),
                  Expanded(
                    child: TextBuilder(
                      text: "Pick ${widget.addon.name.withAorAn} plan",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16),
                      weight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Spacing.vertical(10),
              ...widget.addon.plans.map((GoAddonPlan plan) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => setState(() => _selected = plan),
                      child: GoAddonPlanItem(plan: plan, isSelected: _selected == plan)
                    )
                  ),
                );
              }),
              if(_selected.isNotNull) ...[
                Spacing.vertical(20),
                InteractiveButton(
                  text: "Register addon",
                  borderRadius: 24,
                  width: MediaQuery.sizeOf(context).width,
                  textSize: Sizing.font(14),
                  buttonColor: CommonColors.instance.bluish,
                  textColor: CommonColors.instance.lightTheme,
                  onClick: _register,
                  loading: _isSaving,
                )
              ],
            ],
          ),
        ),
      )
    );
  }
}