import 'package:flutter/material.dart';

import '../../common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          borderRadius: 4.0,
          child: Text(text, style: TextStyle(fontSize: 16.0, color: Colors.white)),
          color: Colors.indigo,
          height: 44.0,
          onPressed: onPressed,
        );
}
