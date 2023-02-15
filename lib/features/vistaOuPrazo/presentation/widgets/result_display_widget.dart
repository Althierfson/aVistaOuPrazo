import 'package:flutter/material.dart';

class ResultDisplayWidget extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  
  const ResultDisplayWidget({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: onPressed,
                  child: const Text(
                    "Calcular",
                    style: TextStyle(fontSize: 18),
                  )),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        child
      ],
    );
  }
}
