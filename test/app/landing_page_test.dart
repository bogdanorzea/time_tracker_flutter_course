import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import '../mocks.dart';


void main() {
  MockAuth mockAuth;
  MockDatabase mockDatabase;
  StreamController<User> onAuthStateChangedController;

  setUp(() {
    mockAuth = MockAuth();
    mockDatabase = MockDatabase();
    onAuthStateChangedController = StreamController<User>();
  });

  tearDown(() {
    onAuthStateChangedController.close();
  });

  Future<void> pumpLandingPage(
    WidgetTester tester, {
    VoidCallback onSignedIn,
  }) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: LandingPage(databaseBuilder: (userId) => mockDatabase),
        ),
      ),
    );

    await tester.pump();
  }

  void stubOnAuthStateChangedYields(Iterable<User> stubOnAuthStateChanged) {
    onAuthStateChangedController.addStream(
      Stream<User>.fromIterable(stubOnAuthStateChanged),
    );

    when(mockAuth.authStateChanges()).thenAnswer(
      (_) => onAuthStateChangedController.stream,
    );
  }

  testWidgets('stream waiting', (tester) async {
    stubOnAuthStateChangedYields([]);

    await pumpLandingPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('null user', (tester) async {
    stubOnAuthStateChangedYields([null]);

    await pumpLandingPage(tester);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('non-null user', (tester) async {
    stubOnAuthStateChangedYields([MockUser.uid('dummy')]);

    await pumpLandingPage(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });
}
