// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// class AuthService {
//   static final _supabase = Supabase.instance.client;

//   // --- Get current user ---
//   static User? get currentUser => _supabase.auth.currentUser;

//   // --- Check if logged in ---
//   static bool get isLoggedIn => currentUser != null;

//   // --- Email/Password Login ---
//   static Future<AuthResponse> signInWithEmail({
//     required String email,
//     required String password,
//   }) async {
//     return await _supabase.auth.signInWithPassword(
//       email: email,
//       password: password,
//     );
//   }

//   // --- Email/Password Sign Up ---
//   static Future<AuthResponse> signUpWithEmail({
//     required String email,
//     required String password,
//     required String fullName,
//   }) async {
//     return await _supabase.auth.signUp(
//       email: email,
//       password: password,
//       data: {'full_name': fullName},
//     );
//   }

//   // --- Google Sign In ---
//   static Future<AuthResponse?> signInWithGoogle() async {
//     const webClientId =
//         '274556405638-ovkl6llfgj9ho536apjqe789313ij9i1.apps.googleusercontent.com';

//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       serverClientId: webClientId,
//     );

//     try {
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) {
//         print('DEBUG: Google sign in cancelled by user');
//         return null;
//       }

//       print('DEBUG: Google user signed in: ${googleUser.email}');

//       final googleAuth = await googleUser.authentication;
//       final accessToken = googleAuth.accessToken;
//       final idToken = googleAuth.idToken;

//       print('DEBUG: accessToken: ${accessToken != null ? 'present' : 'null'}');
//       print('DEBUG: idToken: ${idToken != null ? 'present' : 'null'}');

//       if (accessToken == null) throw Exception('No access token');
//       if (idToken == null) throw Exception('No ID token');

//       return await _supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: idToken,
//         accessToken: accessToken,
//       );
//     } catch (e) {
//       print('DEBUG: Google sign in error: $e');
//       rethrow;
//     }
//   }
//   // --- Facebook Sign In ---
// static Future<AuthResponse?> signInWithFacebook() async {
//   final loginResult = await FacebookAuth.instance.login();

//   if (loginResult.status != LoginStatus.success) {
//     print('DEBUG: Facebook login failed: ${loginResult.status}');
//     return null;
//   }

//   final accessToken = loginResult.accessToken?.tokenString;
//   if (accessToken == null) throw Exception('No Facebook access token');

//   return await _supabase.auth.signInWithIdToken(
//     provider: OAuthProvider.facebook,
//     idToken: accessToken,
//   );
// }

//   // --- Sign Out ---
//   static Future<void> signOut() async {
//     await _supabase.auth.signOut();
//   }
// // --- Forgot Password (send OTP code) ---
// // --- Forgot Password (send OTP code) ---
// static Future<void> resetPassword(String email) async {
//   await _supabase.auth.signInWithOtp(
//     email: email,
//     shouldCreateUser: false,
//     emailRedirectTo: null,
//   );
// }

// // --- Verify OTP code ---
// static Future<AuthResponse> verifyOtp({
//   required String email,
//   required String token,
// }) async {
//   return await _supabase.auth.verifyOTP(
//     email: email,
//     token: token,
//     type: OtpType.email,
//   );
// }
// // --- Update Password ---
// static Future<void> updatePassword(String newPassword) async {
//   await _supabase.auth.updateUser(
//     UserAttributes(password: newPassword),
//   );
// }
// // --- Get current user profile ---
// static Future<Map<String, dynamic>?> getProfile() async {
//   final userId = currentUser?.id;
//   if (userId == null) return null;

//   final response = await _supabase
//       .from('profiles')
//       .select()
//       .eq('id', userId)
//       .single();

//   return response;
// }

// // --- Update user profile ---
// static Future<void> updateProfile({
//   String? fullName,
//   String? phone,
//   String? birthday,
//   String? gender,
// }) async {
//   final userId = currentUser?.id;
//   print('DEBUG: updateProfile called');
//   print('DEBUG: userId = $userId');
//   print('DEBUG: fullName = $fullName');
  
//   if (userId == null) {
//     print('DEBUG: userId is null - user not logged in!');
//     return;
//   }

//   try {
//     final response = await _supabase.from('profiles').upsert({
//       'id': userId,
//       'full_name': ?fullName,
//       'phone': ?phone,
//       'birthday': ?birthday,
//       'gender': ?gender,
//       'updated_at': DateTime.now().toIso8601String(),
//     });
//     print('DEBUG: upsert response = $response');
//   } catch (e) {
//     print('DEBUG: upsert error = $e');
//   }
// }

//   // --- Auth state stream ---
//   static Stream<AuthState> get authStateChanges =>
//       _supabase.auth.onAuthStateChange;
// }
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

  // --- Facebook Sign In ---
  static Future<AuthResponse?> signInWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();

    if (loginResult.status != LoginStatus.success) {
      print('DEBUG: Facebook login failed: ${loginResult.status}');
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
    print('DEBUG: updateProfile called');
    print('DEBUG: userId = $userId');
    print('DEBUG: fullName = $fullName');
    
    if (userId == null) {
      print('DEBUG: userId is null - user not logged in!');
      return;
    }

    try {
      await _supabase.from('profiles').upsert({
        'id': userId,
        if (fullName != null) 'full_name': fullName,
        if (phone != null) 'phone': phone,
        if (birthday != null) 'birthday': birthday,
        if (gender != null) 'gender': gender,
        'updated_at': DateTime.now().toIso8601String(),
      });
      print('DEBUG: upsert success');
    } catch (e) {
      print('DEBUG: upsert error = $e');
    }
  }

  // --- Auth state stream ---
  static Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;
}