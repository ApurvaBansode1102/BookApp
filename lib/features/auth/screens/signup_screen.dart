import 'package:bookapp/features/auth/controller/auth_controller.dart';
import 'package:bookapp/features/auth/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: height * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                'Sign Up',
                style: GoogleFonts.poppins(
                  fontSize: width * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: height * 0.01),

              // Subtitle
              Text(
                'Enter your details below & free sign up',
                style: GoogleFonts.poppins(
                  fontSize: width * 0.035,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: height * 0.05),

              // Name Field
              Text("Your Name", style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),

              SizedBox(height: 20),
              // Email Field
              Text("Your Email", style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                 hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Password Field
              Text("Password", style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 8),
              Obx(() => TextField(
                    controller: passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                     hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                              color: Colors.grey,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  )),

              SizedBox(height: 25),
              // 

              // Checkbox
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.isTermsAccepted.value,
                        onChanged: controller.toggleTerms,
                      ),
                      Expanded(
                        child: Text(
                          "By creating an account you have to agree\nwith our them & condication.",
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(height: 5),


              // Create account button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Registration logic using AuthController
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      final name = nameController.text.trim();
                      if (!controller.isTermsAccepted.value) {
                        Get.snackbar('Error', 'You must accept the terms and conditions.', backgroundColor: Colors.red, colorText: Colors.white);
                        return;
                      }
                      // Use your AuthController for registration
                      await Get.find<AuthController>().register(email, password);
                      // Set display name after registration
                      final user = Get.find<AuthController>().user.value;
                      if (user != null && name.isNotEmpty) {
                        await user.updateDisplayName(name);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3366FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Create account",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

             

              SizedBox(height: 20),

              // Already have an account?
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to login screen
                    Get.toNamed('/login');
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.poppins(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Log in",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF3366FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
