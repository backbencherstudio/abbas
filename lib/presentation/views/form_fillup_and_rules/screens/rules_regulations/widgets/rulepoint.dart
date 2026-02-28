import 'package:flutter/material.dart';

class _RulePoint extends StatelessWidget {
  final String title;
  final String description;

  const _RulePoint(this.title, this.description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•    ',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w400),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w400),
                ),
                TextSpan(text: ' $description'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
