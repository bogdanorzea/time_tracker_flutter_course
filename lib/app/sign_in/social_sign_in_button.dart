import 'package:flutter/material.dart';

import '../../common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String assetName,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(assetName != null),
        assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(text, style: TextStyle(fontSize: 16.0, color: textColor)),
              Opacity(opacity: 0.0, child: Image.asset(assetName)),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
