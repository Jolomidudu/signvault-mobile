import 'package:flutter/foundation.dart';

enum SessionStatus { initializing, unauthenticated, authenticated }

class AppState extends ChangeNotifier {
  SessionStatus _session = SessionStatus.unauthenticated;
  bool _onboardingCompleted = false;

  SessionStatus get session => _session;
  bool get onboardingCompleted => _onboardingCompleted;

  void completeOnboarding() {
    _onboardingCompleted = true;
    notifyListeners();
  }

  void signIn() {
    _session = SessionStatus.authenticated;
    notifyListeners();
  }

  void signOut() {
    _session = SessionStatus.unauthenticated;
    notifyListeners();
  }
}
