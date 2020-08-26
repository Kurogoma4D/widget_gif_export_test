import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key key, this.onPressed, this.label}) : super(key: key);

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 12,
      borderRadius: BorderRadius.circular(48),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
            border: Border.all(color: Color(0x11aaaaaa), width: 4),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
