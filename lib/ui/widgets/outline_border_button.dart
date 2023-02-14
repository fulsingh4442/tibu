import 'package:club_app/constants/constants.dart';
import 'package:flutter/material.dart';

class OutlineBorderButton extends StatefulWidget {
  OutlineBorderButton(
    this.buttonBackground,
    this.verticalPadding,
    this.horizontalPadding,
    this.text,
    this.textStyle, {
    this.onPressed,
  });

  final Color buttonBackground;
  final double verticalPadding;
  final double horizontalPadding;
  final String text;
  final TextStyle textStyle;
  final Function onPressed;

  @override
  _OutlineBorderButtonState createState() => _OutlineBorderButtonState();
}

class _OutlineBorderButtonState extends State<OutlineBorderButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: widget.verticalPadding),
        onSurface: dividerColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: buttonBackgroundColor,
        side:const BorderSide(
          width: 2,
          color: buttonBorderColor,
        ),
      ),

      onPressed: () {
        widget.onPressed();
      },

      //color: widget.buttonBackground,
      child: Text(widget.text, style: widget.textStyle.merge(const TextStyle(color: buttonTextColor, fontFamily: 'Orbitron'))),
    );
  }
}
