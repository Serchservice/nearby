import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class LocationView extends StatefulWidget {
  final Address address;
  final Function(Address)? onSelect;
  final bool withPadding;
  final double fontSize;

  const LocationView({
    super.key,
    required this.address,
    this.onSelect,
    this.withPadding = false,
    this.fontSize = 12
  });

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  final LocationService _locationService = LocationImplementation();

  bool isSearching = false;

  void searchCurrentLocation() {
    setState(() {
      isSearching = true;
    });

    _locationService.getAddress(
      onSuccess: (data, position) {
        setState(() {
          isSearching = false;
        });
        widget.onSelect?.call(data);
      },
      onError: (error) {
        notify.error(message: error);
        setState(() {
          isSearching = false;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.address.place.isEmpty ? () => searchCurrentLocation() : () => widget.onSelect?.call(widget.address),
        child: Padding(
          padding: widget.withPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(widget.address.place.isNotEmpty && !isSearching) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                          text: widget.address.place,
                          size: Sizing.font(widget.fontSize),
                          color: Theme.of(context).primaryColor,
                          lines: 2,
                          flow: TextOverflow.ellipsis
                      ),
                      if(widget.address.country.isNotEmpty) ...[
                        SText(
                          text: widget.address.country,
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColorLight
                        ),
                      ]
                    ],
                  )
                )
              ] else ...[
                LoadingButton(
                  padding: EdgeInsets.symmetric(vertical: Sizing.space(12), horizontal: Sizing.space(22)),
                  text: "Use current location",
                  textColor: Theme.of(context).scaffoldBackgroundColor,
                  buttonColor: Theme.of(context).primaryColor,
                  borderRadius: 24,
                  textSize: 12,
                  loading: isSearching,
                  onClick: () => searchCurrentLocation(),
                ),
              ],
              if(widget.address.place.isNotEmpty && !isSearching) ...[] else ...[
                Spacer()
              ],
              Image(
                image: AssetUtility.image(Assets.mapLocation),
                width: 60,
                height: 60
              )
            ],
          ),
        ),
      ),
    );
  }
}