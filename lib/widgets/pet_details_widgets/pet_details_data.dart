import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetDetailsData extends StatelessWidget {
  const PetDetailsData({
    required this.title,
    required this.data,
    Key? key,
  }) : super(key: key);

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 24,
        end: 32,
      ),
      child: Row(
        children: [
          Text(
            '$title:',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF47C7C),
            ),
          ),
          const Spacer(),
          Text(
            data,
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: const Color(0xFFEB4747),
            ),
          ),
        ],
      ),
    );
  }
}
