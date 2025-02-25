import 'package:flutter/material.dart';

class Response extends StatelessWidget {
  const Response({
    super.key,
    required this.isUser,
    required this.text,
  });

  final bool isUser;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: isUser ? TextAlign.end : TextAlign.start,
      textWidthBasis: TextWidthBasis.longestLine,
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              // backgroundColor: Colors.blue
            ),
          ),
        ],
      ),
    );
  }
}
