import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class AddonVerification extends StatelessWidget {
  final GoAddonVerification verification;
  const AddonVerification({super.key, required this.verification});

  @override
  Widget build(BuildContext context) {
    GoAddon addon = GoAddon.fromJson(verification.toJson());
    GoAddonPlan plan = GoAddonPlan.fromJson(verification.activator.toJson());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GoAddonItem(
          addon: addon,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.vertical(10),
              GoAddonPlanItem(isSelected: true, plan: plan)
            ],
          )
        ),
      ),
    );
  }
}