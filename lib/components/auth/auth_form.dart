import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.isTextObscured,
    this.validator,
    this.onChanged,
    this.maxLines,
    this.keyboardType,
  });

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final int? maxLines;
  final String? hintText;
  final bool? isTextObscured;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontFamily: Constants.inter,
        fontWeight: FontWeight.w600,
        fontSize: Constants.smallSize,
      ),
      validator: widget.validator,
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Constants.greyedText,
          fontFamily: Constants.inter,
          fontWeight: FontWeight.w400,
          fontSize: Constants.smallSize,
        ),
        labelStyle: TextStyle(
          color: Constants.greyedText,
          fontFamily: Constants.inter,
          fontWeight: FontWeight.w400,
          fontSize: Constants.smallSize,
        ),
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,

        suffixIcon: widget.suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: BorderSide(width: 1, color: Constants.primary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: BorderSide(width: 1, color: Constants.greyedText),
        ),
      ),
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
    );
  }
}
