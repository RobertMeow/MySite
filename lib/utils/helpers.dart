import 'package:flutter/cupertino.dart';

void showCupertinoSnackBar({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 2),
}) {
  if (!context.mounted) return;
  
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: CupertinoPopupSurface(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Center(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  try {
    overlay.insert(overlayEntry);
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  } catch (e) {
    print('Error showing snackbar: $e');
  }
}