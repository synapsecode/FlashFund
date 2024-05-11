import 'package:flutter/material.dart';
import 'package:frontend/extensions/extensions.dart';

class StandardButton extends StatefulWidget {
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final Function onTap;
  const StandardButton({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.width,
    required this.onTap,
    required this.textColor,
  });

  @override
  State<StandardButton> createState() => _StandardButtonState();
}

class _StandardButtonState extends State<StandardButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(color: widget.buttonColor, boxShadow: const [
          BoxShadow(
              offset: Offset(4, 4), blurRadius: 0, color: Color(0xFFC9C9C9))
        ]),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
                fontFamily: 'gilroy-bold',
                fontSize: 4 / 100 * widget.width,
                color: widget.textColor,
                letterSpacing: 1.6,
                decoration: TextDecoration.none),
          ),
        ).addVerticalMargin(14),
      ),
    );
  }
}
