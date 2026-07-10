import 'package:firebase_auth/firebase_auth.dart';

// Mirrors ClassChatApp-main's AuthService — same Firebase project, so a
// staff member registered here can also sign in to ClassChatApp and
// vice versa. Email/Password sign-in must be enabled in the Firebase
// console (Authentication > Sign-in method) — it already is, since
// ClassChatApp-main uses it too.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN
  // Returns null on success, or an error message string on failure.
  Future<String?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user != null ? null : "Login failed";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed";
    } catch (e) {
      return "Login failed: $e";
    }
  }

  // REGISTER
  // Returns null on success, or an error message string on failure.
  Future<String?> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user != null ? null : "Registration failed";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Registration failed";
    } catch (e) {
      return "Registration failed: $e";
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // CURRENT USER
  User? get currentUser => _auth.currentUser;
}
