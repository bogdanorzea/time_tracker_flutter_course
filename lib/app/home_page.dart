import 'package:flutter/material.dart';

import '../services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
    @required this.auth,
    @required this.onSignOut,
  }) : super(key: key);

  final VoidCallback onSignOut;
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        actions: [
          TextButton(
            onPressed: _signOut,
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
