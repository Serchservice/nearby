import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class CreateActivityLocationSelector extends StatefulWidget {
  final AddressReceived onAddressReceived;
  const CreateActivityLocationSelector({super.key, required this.onAddressReceived});

  @override
  State<CreateActivityLocationSelector> createState() => _CreateActivityLocationSelectorState();

  static Future<T?> open<T>({required AddressReceived onAddressReceived}) {
    return Navigate.bottomSheet(
      sheet: CreateActivityLocationSelector(onAddressReceived: onAddressReceived),
      route: Navigate.appendRoute("/location_selector"),
    );
  }
}

class _CreateActivityLocationSelectorState extends State<CreateActivityLocationSelector> {
  final LocationService _locationService = LocationImplementation();

  Address? _address;
  bool _isLoading = false;

  @override
  void initState() {
    _getCurrentLocation(false);

    super.initState();
  }

  void _getCurrentLocation(bool showLoading) {
    if(_address.isNotNull) {
      widget.onAddressReceived(_address!);
      Navigate.close(closeAll: false);
    } else {
      if(showLoading) {
        setState(() {
          _isLoading = true;
        });
      }

      _locationService.getAddress(onSuccess: (address, position) {
        if(showLoading) {
          setState(() {
            _isLoading = false;
          });
        }

        ActivityLifeCycle.onAddressChanged(address);
        if(showLoading) {
          widget.onAddressReceived(address);
          Navigate.close(closeAll: false);
        } else {
          setState(() {
            _address = address;
          });
        }
      }, onError: (error) {
        if(showLoading) {
          setState(() {
            _isLoading = false;
          });
        }

        notify.error(message: error);
      });
    }
  }

  @protected
  void onLocationClicked<T>() async {
    if(_isLoading) {
      notify.tip(message: "Please wait... fetching your current location", color: CommonColors.instance.hint);

      return;
    } else {
      T? result = await LocationSearchLayout.to();

      if(result.instanceOf<Address>()) {
        widget.onAddressReceived(result as Address);
      }
    }
  }

  @protected
  List<ButtonView> get actions => [
    ButtonView(
      header: "Use current location",
      icon: Icons.my_location_rounded,
      color: Theme.of(context).primaryColor,
      onClick: () => _getCurrentLocation(true),
      child: _isLoading
        ? Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Loading.circular(color: Theme.of(context).primaryColor, width: 1),
        )
        : Container(),
    ),
    ButtonView(
      header: "Select a location",
      icon: Icons.share_location_rounded,
      color: Theme.of(context).primaryColor,
      onClick: onLocationClicked,
      child: Container()
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      padding: EdgeInsets.zero,
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: BannerAdLayout(
        expandChild: false,
        mainAxisSize: MainAxisSize.min,
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              child: Column(
                children: [
                  ModalBottomSheetIndicator(
                    showButton: PlatformEngine.instance.isWeb,
                    color: CommonColors.instance.darkTheme2,
                    backgroundColor: CommonColors.instance.lightTheme2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBuilder(
                                text: "Select your location",
                                size: Sizing.font(16),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                flow: TextOverflow.ellipsis
                              ),
                              TextBuilder(
                                text: "Pick option for location fetching",
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColorLight,
                                flow: TextOverflow.ellipsis
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Icon(Icons.directions, size: 40, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ...actions.map((ButtonView action) {
              return SmartButton(
                tab: action,
                color: action.color,
                onTap: action.onClick,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                needNotification: action.index.equals(0) && _isLoading.isTrue,
                notification: action.child,
              );
            })
          ],
        ),
      )
    );
  }
}