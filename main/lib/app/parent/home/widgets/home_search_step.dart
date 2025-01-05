import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class HomeSearchStep extends StatefulWidget {
  final String? header;
  final Widget? custom;
  final bool showBottom;
  final double? height;
  final bool isVertical;

  const HomeSearchStep({
    super.key,
    this.showBottom = true,
    this.header,
    this.custom,
    this.height,
    this.isVertical = true,
  });

  @override
  State<HomeSearchStep> createState() => _HomeSearchStepState();
}

class _HomeSearchStepState extends State<HomeSearchStep> {
  final GlobalKey _contentKey = GlobalKey();
  double _calculatedHeight = 50;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_contentKey.currentContext != null) {
        final RenderBox renderBox = _contentKey.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          _calculatedHeight = renderBox.size.height + 20; // Adjust with padding or margin if needed
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVertical ? _buildVertical(context) : _buildHorizontal(context);
  }

  Widget _buildHorizontal(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.5),
      width: 50,
      decoration: BoxDecoration(
        color: CommonColors.color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildVertical(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 15, width: 1.5, color: CommonColors.color),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: CommonColors.color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            if (widget.showBottom) ...[
              Container(height: widget.height ?? _calculatedHeight, width: 1.5, color: CommonColors.color),
            ],
          ],
        ),
        Expanded(
          key: _contentKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(widget.header != null && widget.header!.isNotEmpty) ...[
                SText(
                  text: widget.header!,
                  color: CommonColors.color,
                  size: 14,
                  weight: FontWeight.bold,
                  flow: TextOverflow.clip,
                )
              ],
              if (widget.custom != null) ...[
                widget.custom!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}