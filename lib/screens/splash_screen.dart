import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/preferences/shared_pref_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      String route =
          SharedPrefController().getValueFor<bool>(
                key: PrefKeys.loggedIn.name,
              ) ??
              false
          ? '/home_screen'
          : '/login_screen';
      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [Color(0xFFEF5B0C), Color(0xFFEB4747)],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.pets, color: Color(0xFFFFDEDE), size: 100),
            Text(
              'Pet App',
              style: GoogleFonts.nunito(
                fontSize: 32,
                color: const Color(0xFFFFDEDE),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
