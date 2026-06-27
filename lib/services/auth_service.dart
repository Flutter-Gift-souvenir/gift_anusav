import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) throw Exception('No access token');
      if (idToken == null) throw Exception('No ID token');

      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // --- Facebook Sign In ---
  static Future<AuthResponse?> signInWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();

    if (loginResult.status != LoginStatus.success) {
      return null;
    }

    final accessToken = loginResult.accessToken?.tokenString;
    if (accessToken == null) throw Exception('No Facebook access token');

    return await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.facebook,
      idToken: accessToken,
    );
  }

  // --- Sign Out ---
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

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

  // --- Get current user profile ---
  static Future<Map<String, dynamic>?> getProfile() async {
    final userId = currentUser?.id;
    if (userId == null) return null;

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return response;
  }

  // --- Update user profile ---
  static Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? birthday,
    String? gender,
  }) async {
    final userId = currentUser?.id;

    if (userId == null) {
      return;
    }

    try {
      final Map<String, dynamic> updates = {
        'id': userId,
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (birthday != null) updates['birthday'] = birthday;
      if (gender != null) updates['gender'] = gender;

      await _supabase.from('profiles').upsert(updates);
    } catch (e) {
      rethrow;
    }
  } // <-- This brace was missing, closing updateProfile method cleanly!

  // --- Auth state stream ---
  static Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;
}