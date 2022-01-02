import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInManager {
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  SignInManager({@required this.auth, @required this.isLoading});

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnonymously() => _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() => _signIn(auth.signInWithGoogle);
  Future<User> signInWithFacebook() => _signIn(auth.signInWithFacebook);
}
