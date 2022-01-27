import 'package:flutter/material.dart';

import '../../common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    Key key,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          key: key,
          child: Text(text, style: TextStyle(fontSize: 16.0, color: textColor)),
          color: color,
          onPressed: onPressed,
        );
}
