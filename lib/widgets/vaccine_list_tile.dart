import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VaccineListTile extends StatelessWidget {
  const VaccineListTile({
    required this.name,
    required this.title,
    required this.age,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final String name;
  final String title;
  final String age;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xFFEB4747),
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(
        name,
        style: GoogleFonts.nunito(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      trailing: SizedBox(
        // color: Colors.amber,
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              age,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.delete,
                color: Color(0xFFEB4747),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
