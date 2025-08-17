import 'package:flutter/material.dart';

class MaterialBtn extends StatelessWidget {

  final void Function() onPressed;
  final String btnText;
  const MaterialBtn({
    super.key,
    required this.onPressed,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(width: 1, color: Colors.grey.shade300)
      ),
      color: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      minWidth: double.infinity,
      child: Text(
        btnText,
        style: const TextStyle(fontSize: 18, color: Colors.deepPurpleAccent),
      ),
    );
  }
}