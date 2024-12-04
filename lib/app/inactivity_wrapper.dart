import 'dart:async';
import 'package:drive/configurations/ad_manager/interstitial_ad_manager.dart';
import 'package:flutter/material.dart';

class InactivityWrapper extends StatefulWidget {
  final Widget child;

  const InactivityWrapper({super.key, required this.child});

  @override
  State<InactivityWrapper> createState() => _InactivityWrapperState();
}

class _InactivityWrapperState extends State<InactivityWrapper> {
  Timer? _inactivityTimer;
  final InterstitialAdManager _manager = InterstitialAdManager();

  @override
  void initState() {
    super.initState();
    _startInactivityTimer();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 1), _showInactivityPopup);
  }

  void _resetTimer() {
    if (mounted) {
      _startInactivityTimer();
    }
  }

  void _showInactivityPopup() {
    if (mounted) {
      _manager.showAdIfAvailable();
    }
  }

  void _onUserInteraction() {
    _resetTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _onUserInteraction(),
      child: widget.child,
    );
  }
}