import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInBloc {
  final AuthBase auth;

  SignInBloc({@required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream get isLoadingSteam => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInAnonymously() => _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() => _signIn(auth.signInWithGoogle);
  Future<User> signInWithFacebook() => _signIn(auth.signInWithFacebook);
}
