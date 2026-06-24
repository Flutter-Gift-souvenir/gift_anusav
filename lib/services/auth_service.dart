import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  // --- Get current user ---
  static User? get currentUser => _supabase.auth.currentUser;

  // --- Check if logged in ---
  static bool get isLoggedIn => currentUser != null;

  // --- Email/Password Login ---
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // --- Email/Password Sign Up ---
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  // --- Google Sign In ---
  static Future<AuthResponse?> signInWithGoogle() async {
    const webClientId =
        '274556405638-ovkl6llfgj9ho536apjqe789313ij9i1.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
    );

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('DEBUG: Google sign in cancelled by user');
        return null;
      }

      print('DEBUG: Google user signed in: ${googleUser.email}');

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      print('DEBUG: accessToken: ${accessToken != null ? 'present' : 'null'}');
      print('DEBUG: idToken: ${idToken != null ? 'present' : 'null'}');

      if (accessToken == null) throw Exception('No access token');
      if (idToken == null) throw Exception('No ID token');

      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      print('DEBUG: Google sign in error: $e');
      rethrow;
    }
  }

  // --- Sign Out ---
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
// --- Forgot Password (send OTP code) ---
// --- Forgot Password (send OTP code) ---
static Future<void> resetPassword(String email) async {
  await _supabase.auth.signInWithOtp(
    email: email,
    shouldCreateUser: false,
    emailRedirectTo: null,
  );
}

// --- Verify OTP code ---
static Future<AuthResponse> verifyOtp({
  required String email,
  required String token,
}) async {
  return await _supabase.auth.verifyOTP(
    email: email,
    token: token,
    type: OtpType.email,
  );
}
// --- Update Password ---
static Future<void> updatePassword(String newPassword) async {
  await _supabase.auth.updateUser(
    UserAttributes(password: newPassword),
  );
}

  // --- Auth state stream ---
  static Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;
}