import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PeekAndPop extends StatefulWidget {
  const PeekAndPop(
      {Key? key,
      required,
      required this.onPeek,
      required this.onPop,
      required this.child})
      : super(key: key);

  final VoidCallback onPeek;
  final VoidCallback onPop;
  final Widget child;

  @override
  _PeekAndPopState createState() => _PeekAndPopState();
}

class _PeekAndPopState extends State<PeekAndPop> {
  static const _timerDelaySeconds = 350;
  Timer? _dialogTimer;

  @override
  void dispose() {
    _dialogTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _feedbackAndOnPeek,
      onPointerUp: _feedbackAndOnPop,
      child: widget.child,
    );
  }

  void _feedbackAndOnPeek(PointerDownEvent event) {
    _dialogTimer = Timer(const Duration(milliseconds: _timerDelaySeconds), () {
      HapticFeedback.lightImpact();
      HapticFeedback.mediumImpact();
      HapticFeedback.heavyImpact();
      widget.onPeek();
    });
    setState(() {});
  }

  void _feedbackAndOnPop(PointerUpEvent event) {
    if (_dialogTimer != null && _dialogTimer!.isActive) {
      _dialogTimer?.cancel();
    } else {
      HapticFeedback.heavyImpact();
      HapticFeedback.mediumImpact();
      HapticFeedback.lightImpact();
    }
    _dialogTimer = null;
    setState(() {});
    widget.onPop();
  }
}
