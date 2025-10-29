import 'package:flutter/material.dart';

class ToolRow extends StatelessWidget {
  const ToolRow({
    required this.name,
    required this.type,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final String name;
  final String type;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFEB4747),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            Text(type),
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
