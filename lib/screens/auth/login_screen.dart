import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/database/controllers/user_db_controller.dart';
import '/model/process_response.dart';
import '/utils/helpers.dart';
import '/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            AppTextField(
              textController: _emailTextController,
              hint: 'Email',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 24),
            AppTextField(
              textController: _passwordTextController,
              hint: 'Password',
              obscureText: true,
              prefixIcon: Icons.password_outlined,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFFEB4747),
              ),
              onPressed: () async => await _performLogin(),
              child: Text(
                'Login',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  color: const Color(0xFFFFDEDE),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account', style: GoogleFonts.nunito()),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/register_screen'),
                  child: Text(
                    'Create Now!',
                    style: GoogleFonts.nunito(
                      color: const Color(0xFFF47C7C),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    if (_checkData()) {
      await _login();
    }
  }

  bool _checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  Future<void> _login() async {
    ProcessResponse processResponse = await UserDbController().login(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );
    if (processResponse.success) {
      Navigator.pushReplacementNamed(context, '/home_screen');
    }
    showSnackBar(
      context,
      message: processResponse.message,
      error: !processResponse.success,
    );
  }
}
