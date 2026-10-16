import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signvault/app/app.dart';
import 'package:signvault/app/app_state.dart';
import 'package:signvault/mock/mock_data.dart';

void main() {
  testWidgets('app opens directly to SignVault onboarding', (tester) async {
    await tester.pumpWidget(const SignVaultApp());
    expect(find.text('SignVault'), findsOneWidget);
    expect(find.text('Your Signature.\nYour Control.'), findsOneWidget);
  });

  testWidgets('onboarding advances and Get Started opens welcome', (
    tester,
  ) async {
    await tester.pumpWidget(const SignVaultApp(initialLocation: '/onboarding'));
    expect(find.text('Your Signature.\nYour Control.'), findsOneWidget);
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    expect(find.text('Create. Copy. Sign.'), findsOneWidget);
    await tester.tap(find.text('SKIP'));
    await tester.pumpAndSettle();
    expect(find.text('Built for Trust.'), findsOneWidget);
    await tester.tap(find.text('GET STARTED'));
    await tester.pumpAndSettle();
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('login validates and mock login opens authenticated home', (
    tester,
  ) async {
    await tester.pumpWidget(const SignVaultApp(initialLocation: '/login'));
    await tester.tap(find.text('Sign In').first);
    await tester.pumpAndSettle();
    expect(find.text('Enter your email address'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'alex@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'longpassword',
    );
    await tester.tap(find.text('Sign In').first);
    await tester.pumpAndSettle();
    expect(find.text('Your Signature Vault'), findsOneWidget);
  });

  testWidgets('registration rejects mismatched passwords', (tester) async {
    await tester.pumpWidget(const SignVaultApp(initialLocation: '/register'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'First name'),
      'Alex',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Last name'),
      'Morgan',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'alex@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'longpassword',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm password'),
      'otherpassword',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create Account'));
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('vault shows mock signatures and navigation signs out', (
    tester,
  ) async {
    final appState = AppState()..signIn();
    await tester.pumpWidget(
      SignVaultApp(appState: appState, initialLocation: '/app/vault'),
    );
    expect(find.text('Signature Vault'), findsOneWidget);
    expect(find.text('Professional'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Alex Morgan'), findsOneWidget);
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();
    expect(find.text('Your Signature.\nYour Control.'), findsOneWidget);
    appState.dispose();
  });

  testWidgets('home renders centralized mock signatures', (tester) async {
    final appState = AppState()..signIn();
    await tester.pumpWidget(
      SignVaultApp(appState: appState, initialLocation: '/app/home'),
    );
    expect(find.text('Recent Signatures'), findsOneWidget);
    expect(find.text('Professional'), findsOneWidget);
    expect(mockSignatures, hasLength(4));
    await tester.tap(find.text('Vault').last);
    await tester.pumpAndSettle();
    expect(find.text('Signature Vault'), findsOneWidget);
    appState.dispose();
  });
}
