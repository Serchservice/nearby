import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class CreateActivityButton extends StatelessWidget {
  final ButtonView view;

  const CreateActivityButton({super.key, required this.view});

  @override
  Widget build(BuildContext context) {
    bool isRequired = bool.tryParse(view.body) ?? true;

    return TextButton.icon(
      onPressed: view.onClick,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return view.color.lighten(30);
        }),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6)),
      ),
      icon: Icon(view.icon, size: 20, color: view.color),
      label: Text(
        "${view.header}${isRequired ? " *" : ""}",
        style: TextStyle(fontWeight: FontWeight.bold, color: view.color),
      ),
    );
  }
}

/// **Custom Painter for the Vertical Line + Curved Path**
class TrackPainter extends CustomPainter {
  final Color color;

  TrackPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Makes the line ends smooth

    Path path = Path();
    double verticalStart = 0;
    double verticalEnd = size.height / 2; // Middle point for the curve start
    double curveWidth = size.width; // Width of the curve

    // Draw vertical line
    path.moveTo(0, verticalStart);
    path.lineTo(0, verticalEnd);

    // Draw smooth curved transition (left to right)
    path.quadraticBezierTo(
      curveWidth / 6, verticalEnd + 20, // Control point
      curveWidth - 10, verticalEnd / 0.7, // End point of the curve
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// **Helper to Calculate Child Height**
double childHeight(Widget child) {
  return 50;
}