import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class StepItem extends StatefulWidget {
  final String title;
  final bool showBottom;
  final double? height;

  const StepItem({super.key, this.showBottom = true, required this.title, this.height}) ;

  @override
  State<StepItem> createState() => _StepItemState();
}

class _StepItemState extends State<StepItem> {
  final GlobalKey _key = GlobalKey();
  double _height = 50;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(_key.currentContext != null) {
        final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          _height = renderBox.size.height + 10;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget text = TextBuilder(
      key: _key,
      text: widget.title,
      color: Theme.of(context).primaryColor,
      size: Sizing.font(14),
      flow: TextOverflow.clip
    );

    return Opacity(
      opacity: 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Sizing.space(15),
                width: Sizing.space(1.5),
                color: Theme.of(context).primaryColor,
              ),
              Container(
                padding: EdgeInsets.all(Sizing.space(4)),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(1)
                ),
              ),
              if(widget.showBottom) ...[
                Container(
                  height: Sizing.space(widget.height ?? _height),
                  width: Sizing.space(1.5),
                  color: Theme.of(context).primaryColor,
                )
              ],
            ],
          ),
          Spacing.horizontal(10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Sizing.space(10)),
              child: text,
            ),
          )
        ],
      ),
    );
  }
}