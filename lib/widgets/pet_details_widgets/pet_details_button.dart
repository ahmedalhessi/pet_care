import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetDetailsButton extends StatelessWidget {
  const PetDetailsButton({
    required this.title,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF47C7C),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFF47C7C),
            ),
          ),
        ],
      ),
    );
  }
}
