import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class GoDelete<T> extends StatefulWidget {
  final T data;
  const GoDelete({super.key, required this.data});

  static void open<T>(T data) {
    if(data.instanceOf<GoActivity>() || data.instanceOf<GoBCap>()) {
      GoActivity? activity = data.instanceOf<GoActivity>() ? data as GoActivity : null;
      GoBCap? bcap = data.instanceOf<GoBCap>() ? data as GoBCap : null;

      String route = activity.isNotNull ? activity!.id : bcap!.id;
      Navigate.bottomSheet(
        sheet: GoDelete<T>(data: data),
        route: Navigate.appendRoute("/delete?with=$route"),
        isScrollable: true
      );
    }
  }

  @override
  State<GoDelete<T>> createState() => _GoDeleteState<T>();
}

class _GoDeleteState<T> extends State<GoDelete<T>> {
  bool _isDeleting = false;

  GoActivity? activity;
  GoBCap? bcap;
  GoInterest? interest;

  @override
  void initState() {
    activity = widget.data.instanceOf<GoActivity>() ? widget.data as GoActivity : null;
    bcap = widget.data.instanceOf<GoBCap>() ? widget.data as GoBCap : null;
    interest = activity?.interest ?? bcap?.interest;

    super.initState();
  }

  void _delete() async {
    if(_isDeleting) return;

    setState(() => _isDeleting = true);

    if(activity.isNotNull) {
      bool isDeleted = await ActivityService.instance.delete(activity!);
      setState(() => _isDeleting = false);

      if(isDeleted) {
        ActivityController.data.onGoActivityDeleted(activity!);
        CentreController.data.onGoActivityDeleted(activity!);

        if(Navigate.previousRoute.notEquals(ParentLayout.route)) {
          Navigate.all(ParentLayout.route);
        } else {
          Navigate.close();
        }
      }
    } else if(bcap.isNotNull) {
      bool isDeleted = await BCapService.instance.delete(bcap!.id);
      setState(() => _isDeleting = false);

      if(isDeleted) {
        BCapController.data.onGoBCapDeleted(bcap!);
        CentreController.data.onGoBCapDeleted(bcap!);
        BCapController.data.bcapController.refresh();
        CentreController.data.bcapController.refresh();

        if(Navigate.previousRoute.notEquals(ParentLayout.route)) {
          Navigate.all(ParentLayout.route);
        } else {
          Navigate.close();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: BannerAdLayout(
          expandChild: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(Sizing.space(2)),
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
              ),
              Spacing.vertical(20),
              TextBuilder(
                text: activity.isNotNull ? "Delete Activity" : "Delete BCAP",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(22),
                weight: FontWeight.bold,
              ),
              TextBuilder(
                text: activity.isNotNull ? "Are you sure you want to delete this activity?" : "Are you sure you want to delete this BCAP?",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(14),
              ),
              Spacing.vertical(30),
              InteractiveButton(
                text: "Yes, continue",
                borderRadius: 24,
                width: MediaQuery.sizeOf(context).width,
                textSize: Sizing.font(14),
                buttonColor: CommonColors.instance.error,
                textColor: CommonColors.instance.lightTheme,
                onClick: _delete,
                loading: _isDeleting,
              )
            ],
          ),
        ),
      )
    );
  }
}