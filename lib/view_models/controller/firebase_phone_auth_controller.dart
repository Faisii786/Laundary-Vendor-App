import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/utils/Colors.dart';

/// FirebasePhoneAuthController - Middleware for Firebase Phone OTP Authentication
///
/// This controller handles:
/// - Sending OTP to phone number
/// - Verifying OTP code
/// - Managing verification state
/// - Auto-retrieval of OTP on Android
class FirebasePhoneAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Verification state
  String _verificationId = '';
  int? _resendToken;

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isOtpSent = false.obs;
  final RxBool isVerified = false.obs;
  final RxString errorMessage = ''.obs;

  // Timer for resend
  final RxInt secondsRemaining = 60.obs;
  final RxBool canResend = false.obs;
  Timer? _timer;

  // Callbacks
  Function(String verificationId)? onCodeSent;
  Function(PhoneAuthCredential credential)? onAutoVerified;
  Function(String error)? onError;
  Function()? onVerificationSuccess;

  /// Get the verification ID
  String get verificationId => _verificationId;

  /// Send OTP to the given phone number
  ///
  /// [phoneNumber] - The phone number without country code
  /// [countryCode] - The country code (e.g., +92)
  /// Returns true if OTP was sent successfully, false otherwise
  Future<bool> sendOTP({
    required String phoneNumber,
    required String countryCode,
  }) async {
    // Use a Completer to wait for the Firebase callback
    final Completer<bool> completer = Completer<bool>();

    try {
      isLoading.value = true;
      errorMessage.value = '';
      isOtpSent.value = false;

      final String fullPhoneNumber = '$countryCode$phoneNumber';
      print('📱 Sending OTP to: $fullPhoneNumber');

      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,

        // Called when verification is completed automatically (Android only)
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('✅ Auto verification completed');
          isLoading.value = false;
          isVerified.value = true;
          isOtpSent.value = true;

          if (onAutoVerified != null) {
            onAutoVerified!(credential);
          }

          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },

        // Called when verification fails
        verificationFailed: (FirebaseAuthException e) {
          print('❌ Verification failed!');
          print('❌ Error Code: ${e.code}');
          print('❌ Error Message: ${e.message}');
          print('❌ Full Error: $e');

          isLoading.value = false;
          errorMessage.value = _getErrorMessage(e.code, e.message);

          _showToastMessage(errorMessage.value);

          if (onError != null) {
            onError!(errorMessage.value);
          }

          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },

        // Called when OTP is sent successfully
        codeSent: (String verificationId, int? resendToken) {
          print('📨 OTP sent successfully. VerificationId: $verificationId');
          _verificationId = verificationId;
          _resendToken = resendToken;

          isLoading.value = false;
          isOtpSent.value = true;

          // Start countdown timer
          _startResendTimer();

          _showToastMessage('OTP sent successfully'.tr);

          if (onCodeSent != null) {
            onCodeSent!(verificationId);
          }

          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },

        // Called when automatic code retrieval times out
        codeAutoRetrievalTimeout: (String verificationId) {
          print('⏰ Auto retrieval timeout');
          _verificationId = verificationId;
        },
      );

      // Wait for the callback to complete
      return await completer.future;
    } catch (e) {
      print('❌ Error sending OTP: $e');
      isLoading.value = false;
      errorMessage.value = 'Failed to send OTP: $e'.tr;
      _showToastMessage(errorMessage.value);

      if (!completer.isCompleted) {
        completer.complete(false);
      }
      return false;
    }
  }

  /// Verify the OTP code entered by user
  ///
  /// [otpCode] - The 6-digit OTP code
  /// Returns true if verification is successful
  Future<bool> verifyOTP({required String otpCode}) async {
    if (_verificationId.isEmpty) {
      _showToastMessage('Please request OTP first'.tr);
      return false;
    }

    if (otpCode.length != 6) {
      _showToastMessage('Please enter a valid 6-digit OTP'.tr);
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Create credential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpCode,
      );

      // Sign in with credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        print('✅ OTP verified successfully');
        isLoading.value = false;
        isVerified.value = true;

        if (onVerificationSuccess != null) {
          onVerificationSuccess!();
        }

        return true;
      }

      isLoading.value = false;
      return false;
    } on FirebaseAuthException catch (e) {
      print('❌ OTP verification failed: ${e.message}');
      print('❌ Error code: ${e.code}');
      isLoading.value = false;
      errorMessage.value = _getErrorMessage(e.code, e.message);
      _showToastMessage(errorMessage.value);
      return false;
    } catch (e) {
      print('❌ Error verifying OTP: $e');
      isLoading.value = false;
      errorMessage.value = 'Verification failed. Please try again.'.tr;
      _showToastMessage(errorMessage.value);
      return false;
    }
  }

  /// Resend OTP to the same phone number
  Future<void> resendOTP({
    required String phoneNumber,
    required String countryCode,
  }) async {
    if (!canResend.value) {
      _showToastMessage('Please wait ${secondsRemaining.value} seconds'.tr);
      return;
    }

    await sendOTP(phoneNumber: phoneNumber, countryCode: countryCode);
  }

  /// Start the resend countdown timer
  void _startResendTimer() {
    _timer?.cancel();
    secondsRemaining.value = 60;
    canResend.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Get user-friendly error message
  String _getErrorMessage(String code, [String? message]) {
    print('🔍 Getting error message for code: $code');

    switch (code) {
      case 'invalid-phone-number':
        return 'Invalid phone number format'.tr;
      case 'too-many-requests':
        return 'Too many requests. Please try again later.'.tr;
      case 'invalid-verification-code':
        return 'Invalid OTP code. Please try again.'.tr;
      case 'session-expired':
        return 'Session expired. Please request a new OTP.'.tr;
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.'.tr;
      case 'user-disabled':
        return 'This phone number has been disabled.'.tr;
      case 'operation-not-allowed':
        return 'Phone authentication is not enabled in Firebase.'.tr;
      case 'app-not-authorized':
        return 'App not authorized. Check Firebase configuration.'.tr;
      case 'invalid-app-credential':
        return 'Invalid app credential. Check SHA-1 key in Firebase.'.tr;
      case 'missing-client-identifier':
        return 'Missing reCAPTCHA or SHA-1 configuration.'.tr;
      case 'unknown':
        // Show the actual message for unknown errors
        return message ?? 'Unknown error occurred'.tr;
      default:
        // For debugging - show the actual error code
        print('⚠️ Unhandled error code: $code');
        return message ?? 'Error: $code'.tr;
    }
  }

  /// Show toast message
  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: BlackColor.withOpacity(0.9),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Reset the controller state
  void reset() {
    _verificationId = '';
    _resendToken = null;
    isLoading.value = false;
    isOtpSent.value = false;
    isVerified.value = false;
    errorMessage.value = '';
    secondsRemaining.value = 60;
    canResend.value = false;
    _timer?.cancel();
  }

  /// Sign out from Firebase Auth
  Future<void> signOut() async {
    await _auth.signOut();
    reset();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
