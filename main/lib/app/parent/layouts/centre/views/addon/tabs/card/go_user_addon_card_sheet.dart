import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class GoUserAddonCardSheet extends StatefulWidget {
  final GoUserAddon addon;
  final GoUserAddonUpdated onUpdated;

  const GoUserAddonCardSheet({super.key, required this.addon, required this.onUpdated});

  static void open(GoUserAddon addon, GoUserAddonUpdated onUpdated) {
    Navigate.bottomSheet(
      sheet: GoUserAddonCardSheet(addon: addon, onUpdated: onUpdated),
      isScrollable: true,
      route: Navigate.appendRoute("/${addon.name}}")
    );
  }

  @override
  State<GoUserAddonCardSheet> createState() => _GoUserAddonCardSheetState();
}

class _GoUserAddonCardSheetState extends State<GoUserAddonCardSheet> {
  final ConnectService _connect = Connect();
  late GoUserAddon _addon;
  GoAddonPlan? _selected;
  bool _isSwitching = false;
  bool _isActivating = false;
  bool _isCancelling = false;
  bool _isRenewing = false;
  bool _isCancellingSwitch = false;
  bool _useExistingAuthorization = true;

  bool _canCancelSwitch = false;
  String? _switchDate;

  @override
  void initState() {
    setState(() {
      _addon = widget.addon;

      if(widget.addon.switching.isNotNull) {
        _selected = GoAddonPlan(
          id: widget.addon.switching!.id,
          name: widget.addon.switching!.name,
          description: widget.addon.switching!.description,
          amount: widget.addon.switching!.amount,
          interval: widget.addon.switching!.interval,
          currency: widget.addon.switching!.currency
        );

        _canCancelSwitch = widget.addon.switching!.canCancel;
        _switchDate = widget.addon.switching!.startsWhen;
      }
    });

    super.initState();
  }

  List<ButtonView> get buttons => [
    if(_addon.switching.isNull && _selected.isNotNull) ...[
      ButtonView(
        header: "Switch to ${_selected!.name}",
        onClick: _switch,
        color: CommonColors.instance.bluish,
        body: _isSwitching.toString()
      ),
    ],
    if(_addon.constraint.canActivate) ...[
      ButtonView(
        header: "Activate ${_addon.name}",
        onClick: _activate,
        color: CommonColors.instance.green,
        body: _isActivating.toString()
      ),
    ],
    if(_addon.constraint.canCancel) ...[
      ButtonView(
        header: "Cancel ${_addon.name}",
        onClick: _cancel,
        color: CommonColors.instance.error,
        body: _isCancelling.toString()
      ),
    ],
    if(_addon.constraint.canRenew) ...[
      ButtonView(
        header: "Delete ${_addon.name}",
        onClick: _renew,
        color: CommonColors.instance.warning,
        body: _isRenewing.toString()
      ),
    ],
  ];

  void _switch() async {
    if(_isSwitching) {
      return;
    } else if(_selected.isNotNull) {
      setState(() => _isSwitching = true);
      Outcome response = await _connect.patch(endpoint: "/go/addon/switch?id=${_selected!.id}&useExistingAuthorization=$_useExistingAuthorization");

      if(response.isSuccessful) {
        try {
          InitializePayment payment = InitializePayment.fromJson(response.data);
          Navigate.close(closeAll: false);

          await RouteNavigator.openWeb(
            header: "Switch from ${_addon.name} to ${_selected!.name}",
            url: payment.authorizationUrl,
            params: {"reference": payment.reference}
          );

          await VerifyTransaction.open(payment.reference);
          AddonController.data.fetchUserAddons();
        } catch(_) {
          AddonController.data.fetchUserAddons();
        }

        setState(() => _isSwitching = false);
        notify.success(message: response.message);
        Navigate.close(closeAll: false);
      } else {
        setState(() => _isSwitching = false);
        notify.error(message: response.message);
      }
    } else {
      notify.warn(message: "You need to select a plan to continue");
    }
  }

  void _activate() async {
    if(_isActivating) {
      return;
    } else {
      setState(() => _isActivating = true);
      Outcome response = await _connect.patch(endpoint: "/go/addon/activate?id=${_addon.id}");

      if(response.isSuccessful) {
        AddonController.data.fetchUserAddons();
        setState(() => _isActivating = false);
        notify.success(message: response.message);
        Navigate.close(closeAll: false);
      } else {
        setState(() => _isActivating = false);
        notify.error(message: response.message);
      }
    }
  }

  void _cancel() async {
    if(_isCancelling) {
      return;
    } else {
      setState(() => _isCancelling = true);
      Outcome response = await _connect.patch(endpoint: "/go/addon/cancel?id=${_addon.id}");

      if(response.isSuccessful) {
        AddonController.data.fetchUserAddons();
        setState(() => _isCancelling = false);
        notify.success(message: response.message);
        Navigate.close(closeAll: false);
      } else {
        setState(() => _isCancelling = false);
        notify.error(message: response.message);
      }
    }
  }

  void _cancelSwitch() async {
    if(_isCancellingSwitch) {
      return;
    } else {
      setState(() => _isCancellingSwitch = true);
      Outcome response = await _connect.patch(endpoint: "/go/addon/switch/cancel?id=${_addon.id}");

      if(response.isSuccessful) {
        AddonController.data.fetchUserAddons();
        setState(() => _isCancellingSwitch = false);
        notify.success(message: response.message);
        Navigate.close(closeAll: false);
      } else {
        setState(() => _isCancellingSwitch = false);
        notify.error(message: response.message);
      }
    }
  }

  void _renew() async {
    if(_isRenewing) {
      return;
    } else {
      setState(() => _isRenewing = true);
      Outcome response = await _connect.patch(endpoint: "/go/addon/renew?id=${_addon.id}&useExistingAuthorization=$_useExistingAuthorization");

      if(response.isSuccessful) {
        try {
          InitializePayment payment = InitializePayment.fromJson(response.data);
          Navigate.close(closeAll: false);

          await RouteNavigator.openWeb(
            header: "Switch from ${_addon.name} to ${_selected!.name}",
            url: payment.authorizationUrl,
            params: {"reference": payment.reference}
          );

          await VerifyTransaction.open(payment.reference);
          AddonController.data.fetchUserAddons();
        } catch(_) {
          AddonController.data.fetchUserAddons();
        }

        setState(() => _isSwitching = false);
        notify.success(message: response.message);
        Navigate.close(closeAll: false);
      } else {
        setState(() => _isRenewing = false);
        notify.error(message: response.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      borderRadius: BorderRadius.zero,
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: SingleChildScrollView(
        child: BannerAdLayout(
          expandChild: false,
          child: Column(
            spacing: 5,
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
                      text: "Your ${_addon.name} addon",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16),
                      weight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Spacing.vertical(5),
              Center(child: GoCreditCardItem(card: _addon.card)),
              Spacing.vertical(5),
              GoAddonItem(
                addon: _addon.addon,
                child: (_addon.constraint.canSwitch && _addon.switching.isNull) ? Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _addon.addon.plans.map((GoAddonPlan plan) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => setState(() => _selected = plan),
                        child: GoAddonPlanItem(isSelected: _selected == plan, plan: plan)
                      )
                    );
                  }).toList()
                ) : null
              ),
              Spacing.vertical(5),
              if(_addon.switching.isNotNull) ...[
                Container(
                  padding: EdgeInsets.only(top: 2, left: 4, right: 4, bottom: 2),
                  decoration: BoxDecoration(
                    color: CommonColors.instance.warning.lighten(55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextBuilder(
                    text: _switchDate.isNotNull && _switchDate!.isNotEmpty
                      ? "You have a pending switch to another plan happening in ${_switchDate!}"
                      : "You have a pending switch to another plan",
                    size: 12,
                    weight: FontWeight.bold,
                    autoSize: false,
                    color: CommonColors.instance.warning
                  )
                ),
                Spacing.vertical(5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: GoAddonPlanItem(bgColor: CommonColors.instance.allDay, plan: _selected!)
                ),
                Spacing.vertical(5),
                if(_canCancelSwitch) ...[
                  InteractiveButton(
                    text: "Cancel ${_selected!.name} switch",
                    borderRadius: 24,
                    width: MediaQuery.sizeOf(context).width,
                    textSize: Sizing.font(14),
                    buttonColor: CommonColors.instance.allDay,
                    textColor: CommonColors.instance.lightTheme,
                    onClick: _cancelSwitch,
                    loading: _isCancellingSwitch,
                  )
                ]
              ],
              if((_addon.constraint.canSwitch && _addon.switching.isNull && _selected.isNotNull) || _addon.constraint.canRenew) ...[
                Spacing.vertical(5),
                Row(
                  spacing: 30,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextBuilder(
                        text: "Use an existing card for this transaction",
                        size: 14,
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    Switcher(
                      onChanged: (bool value) => setState(() => _useExistingAuthorization = value),
                      value: _useExistingAuthorization
                    )
                  ],
                ),
              ],
              Spacing.vertical(15),
              ...buttons.map((ButtonView button) {
                return InteractiveButton(
                  text: button.header,
                  borderRadius: 24,
                  width: MediaQuery.sizeOf(context).width,
                  textSize: Sizing.font(14),
                  buttonColor: button.color,
                  textColor: CommonColors.instance.lightTheme,
                  onClick: button.onClick,
                  loading: bool.parse(button.body),
                );
              }),
            ],
          ),
        ),
      )
    );
  }
}