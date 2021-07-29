import 'package:flutter/material.dart';

import 'auth.dart';

class AuthProvider extends InheritedWidget {
  AuthProvider({
    Key key,
    @required this.child,
    @required this.auth,
  }) : super(key: key, child: child);

  final Widget child;
  final AuthBase auth;

  static AuthBase of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();

    return provider.auth;
  }

  @override
  bool updateShouldNotify(AuthProvider oldWidget) => false;
}
