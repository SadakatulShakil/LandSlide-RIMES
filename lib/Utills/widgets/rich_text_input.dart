// widgets/rich_text_input.dart
import 'package:flutter/material.dart';

class RichTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const RichTextInput({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<RichTextInput> createState() => _RichTextInputState();
}

class _RichTextInputState extends State<RichTextInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}