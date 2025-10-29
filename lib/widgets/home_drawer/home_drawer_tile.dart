import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({required this.title, required this.onPressed, super.key});

  final String title;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 16,
          color: const Color(0xFFF37878),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFFF37878)),
      ),
    );
  }
}
