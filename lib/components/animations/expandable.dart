import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class Expandable extends StatefulWidget {
  final Widget header;
  final Widget content;
  final Color? mainColor;
  const Expandable({
    super.key,
    required this.header,
    required this.content,
    this.mainColor,
  });

  @override
  State<Expandable> createState() => _ExpandableState();
}


class _ExpandableState extends State<Expandable> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.mainColor != null
        ? EdgeInsets.all(Sizing.space(6))
        : EdgeInsets.all(Sizing.space(2)),
      color: widget.mainColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: widget.mainColor == null
              ? BorderRadius.circular(16)
              : BorderRadius.zero,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleExpanded,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: widget.header),
                      Icon(
                        _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).primaryColor
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: widget.content
          ),
        ],
      ),
    );
  }
}