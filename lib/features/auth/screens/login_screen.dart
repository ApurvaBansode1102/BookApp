import 'package:bookapp/features/auth/controller/auth_controller.dart';
import 'package:bookapp/features/auth/controller/login_controller.dart';
import 'package:bookapp/features/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
          horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
          vertical: Responsive.padding(context, mobile: 40, tablet: 80),
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Log In",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.05),

              // Email field
              Text("Your Email", style: GoogleFonts.poppins(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                 hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password field
              Text("Password", style: GoogleFonts.poppins(fontSize: 14)),
              const SizedBox(height: 8),
              Obx(() => TextField(
                    controller: passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                     hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  )),

              const SizedBox(height: 10),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Forgot password logic
                  },
                  child: Text(
                    "Forget password?",
                    style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Login logic
                   // showSuccessDialog();
                  // Get.toNamed('/main');
                   authController.login(
      emailController.text.trim(),
      passwordController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3366FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Log In",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Don't have an account? Sign up
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.toNamed('/signup'); // Navigate to sign-up screen
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.poppins(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Sign up",
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

              const SizedBox(height: 15),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Or login with",
                      style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 15),

              // Google Button
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Handle Google Sign-In
                        authController.signInWithGoogle();

                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 30,
                      width: 30,
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




