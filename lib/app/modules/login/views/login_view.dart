import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());

  final TextEditingController _phoneController =
  TextEditingController(text: "0966817805");

  final TextEditingController _passwordController =
  TextEditingController(text: "ngimpanha0");

  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields");
      return;
    }

    controller.login(
      username: username,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= LOGO SECTION =================
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(top: -100, left: -100, child: _decorCircle(250)),
                    Positioned(
                        bottom: -80, right: -80, child: _decorCircle(200)),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_rounded,
                              size: 70, color: Color(0xFF003D6B)),
                          SizedBox(height: 10),
                          Text(
                            'Eshop Online',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF003D6B),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Smart Retail Management',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF5A7C92),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ================= FORM SECTION =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome!',
                      style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text('Sign in to continue',
                        style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 30),

                    // ================= PHONE =================
                    _inputField(
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      hint: "Phone Number",
                    ),

                    const SizedBox(height: 16),

                    // ================= PASSWORD =================
                    _inputField(
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      hint: "Password",
                      obscure: _obscurePassword,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(color: Color(0xFF003D6B)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= LOGIN BUTTON =================
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                        controller.loading.value ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003D6B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: controller.loading.value
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 17, color: Colors.white),
                        ),
                      ),
                    )),

                    const SizedBox(height: 24),

                    // ================= REGISTER =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Not a member? ",
                            style: TextStyle(color: Colors.grey[600])),
                        // TextButton(
                        //   onPressed: () => Get.toNamed(Routes.REGISTER),
                        //   child: const Text(
                        //     "Register now",
                        //     style: TextStyle(
                        //       color: Color(0xFF003D6B),
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ================= SOCIAL LOGIN =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _SocialLoginButton(
                          icon: Icons.facebook,
                          color: Color(0xFF1877F2),
                        ),
                        SizedBox(width: 16),
                        _SocialLoginButton(
                          icon: Icons.g_mobiledata,
                          color: Color(0xFFEA4335),
                        ),
                        SizedBox(width: 16),
                        _SocialLoginButton(
                          icon: Icons.apple,
                          color: Color(0xFF2C2C2C),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8FAFB),
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _decorCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF003D6B).withOpacity(0.08),
      ),
    );
  }
}

// ================= SOCIAL LOGIN BUTTON =================
class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SocialLoginButton({
    Key? key,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Icon(icon, color: color),
    );
  }
}
