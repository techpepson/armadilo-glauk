import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';

class EmptyWidget extends StatefulWidget {
  const EmptyWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(widget.icon, size: 60, color: Constants.greyedText),
          SizedBox(height: 8),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: Constants.mediumSize,
              fontWeight: FontWeight.w400,
              fontFamily: Constants.roboto,
              color: Constants.greyedText,
            ),
          ),
          SizedBox(height: 5),
          Text(
            widget.subtitle,
            style: TextStyle(
              fontSize: Constants.smallSize,
              fontWeight: FontWeight.w400,
              fontFamily: Constants.roboto,
              color: Constants.greyedText,
            ),
          ),
        ],
      ),
    );
  }
}
