import 'package:flutter/material.dart';

class PetDetailsDivider extends StatelessWidget {
  const PetDetailsDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      indent: 25,
      endIndent: 25,
      thickness: 0.65,
      height: 25,
      color: Color(0xFFEB4747),
    );
  }
}
