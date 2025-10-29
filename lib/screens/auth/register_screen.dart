import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/database/controllers/user_db_controller.dart';
import '/model/process_response.dart';
import '/model/user.dart';
import '/utils/helpers.dart';
import '/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  late TextEditingController _nameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
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
              textController: _nameTextController,
              hint: 'Name',
              prefixIcon: Icons.person,
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
              onPressed: () async => await _performRegister(),
              child: Text(
                'Register Now',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  color: const Color(0xFFFFDEDE),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performRegister() async {
    if (_checkData()) {
      await _register();
    }
  }

  bool _checkData() {
    if (_nameTextController.text.isNotEmpty &&
        _emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }

    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  Future<void> _register() async {
    ProcessResponse processResponse = await UserDbController().register(
      user: user,
    );
    if (processResponse.success) {
      Navigator.pop(context);
    }
    showSnackBar(
      context,
      message: processResponse.message,
      error: !processResponse.success,
    );
  }

  User get user {
    User user = User();
    user.name = _nameTextController.text;
    user.email = _emailTextController.text;
    user.password = _passwordTextController.text;
    return user;
  }
}
