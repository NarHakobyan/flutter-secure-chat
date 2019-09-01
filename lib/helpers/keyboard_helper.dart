import 'package:flutter/services.dart';

class KeyboardHelper {
  static hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }
}