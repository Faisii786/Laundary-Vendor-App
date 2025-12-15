import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';
class Languages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US' :{
      'email_hint' : "Enter your email address",
     'password_hint' : "Password",
      'remember_me' : "Remember Me",
      'sign_start' : "Sign in to start",
      'login' : "Login",
      'internet_exception': "We're unable to show results.\nPlease check your data\nconnection.",
     'general_exception': "We're unable to process your request.\nPlease try again.",
      'welcome_back': "Welcome Back",
      'store_app' : "Store App",
      'sign_in' : "Sign in!",
      'greeting_text' : "Welcome back you’ve been missed!",
     'success_login' : "Login Successfully",
      'activity' : "Activity",
      'enter_code' : "Enter the 4-digit Code",
    },
    'ur_PK' :{
      'email_hint' : ' ای میل'
    }
  };
}