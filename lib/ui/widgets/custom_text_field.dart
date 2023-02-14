import 'package:club_app/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(this.controller, this.autoValidate, this.inputType,
      this.textStyle, this.hintText,
      {this.cursorColor = colorPrimaryText,
      this.borderColor = colorPrimaryText,
      this.validator,
      this.maxLength,
        this.maxLines = 1,
      this.obscureText = false,
      this.inputAction = TextInputAction.done,
      this.focusNode = null,
      this.onFieldSubmitted = null,
      this.isEnabled = true});

  final TextEditingController controller;
  final bool autoValidate;
  final Color cursorColor;
  final TextInputType inputType;
  final TextStyle textStyle;
  final String hintText;
  final Color borderColor;
  final Function(String text) validator;
  final int maxLength;
  final int maxLines;
  bool obscureText = false;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final ValueChanged<String> onFieldSubmitted;
  final bool isEnabled;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: widget.autoValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      cursorColor: widget.cursorColor,
      keyboardType: widget.inputType,
      enabled: widget.isEnabled,
      validator: (String value) {
        return widget.validator(value);
      },
      autofocus: false,
      maxLines: widget.maxLines,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      style: widget.textStyle,
      decoration: InputDecoration(
        labelText: widget.hintText,
        labelStyle: widget.textStyle,
        counterText: '',
        contentPadding:
            const EdgeInsets.only(left: 5.0, top: 4.0, right: 0.0, bottom: 4.0),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.borderColor.withAlpha(125),
                style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: widget.borderColor, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: widget.borderColor, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
      ),
      textInputAction: widget.inputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      focusNode: widget.focusNode,
    );
  }
}
