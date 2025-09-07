import 'package:get/get.dart';

class SignUpController extends GetxController {
  var isPasswordHidden = true.obs;
  var isTermsAccepted = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleTerms(bool? value) {
    isTermsAccepted.value = value ?? false;
  }
}
