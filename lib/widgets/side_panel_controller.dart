import 'package:flutter/material.dart';

class SidePanelController {
  OverlayEntry? _entry;
  late AnimationController _animationController;

  void show({
    required BuildContext context,
    required double panelWidth,
    required double topOffset,
    required Widget child,
  }) {
    if (_entry != null) return; // Prevent multiple panels

    final overlay = Overlay.of(context);

    _animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );

    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            // ---- DARK OVERLAY BELOW NAVBAR ----
            Positioned(
              top: topOffset,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: hide,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),

            // ---- SLIDING PANEL ----
            Positioned(
              top: topOffset,
              right: 0,
              bottom: 0,
              width: panelWidth,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, childWidget) {
                  final slide = Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOutCubic,
                  ));

                  return SlideTransition(
                    position: slide,
                    child: childWidget,
                  );
                },
                child: Material(
                  elevation: 8,
                  color: Colors.white,
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
    _animationController.forward();
  }

  void hide() {
    if (_entry == null) return;

    _animationController.reverse().then((_) {
      _entry?.remove();
      _entry = null;
    });
  }
}
