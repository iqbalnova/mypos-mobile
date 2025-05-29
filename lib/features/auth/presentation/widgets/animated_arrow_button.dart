import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/common/styles.dart';

class AnimatedArrowButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const AnimatedArrowButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<AnimatedArrowButton> createState() => _AnimatedArrowButtonState();
}

class _AnimatedArrowButtonState extends State<AnimatedArrowButton> {
  int _activeArrowIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _activeArrowIndex = (_activeArrowIndex + 1) % 3;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Widget> _buildArrows() {
    return List.generate(3, (index) {
      return AnimatedOpacity(
        opacity: index == _activeArrowIndex ? 1.0 : 0.2,
        duration: const Duration(milliseconds: 200),
        child: const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(widget.text, style: AppTextStyle.button()),
              ),
            ),
            Row(children: _buildArrows()),
          ],
        ),
      ),
    );
  }
}
