import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import 'dart:ui' show Color;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:berht_dev/theme/app_theme.dart';

class StickerAnimation extends StatefulWidget {
  final int stickerId;
  final double width;
  final double height;
  
  const StickerAnimation({
    super.key, 
    required this.stickerId,
    this.width = 352,
    this.height = 352,
  });

  @override
  State<StickerAnimation> createState() => _StickerAnimationState();
}

class _StickerAnimationState extends State<StickerAnimation> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  bool _isLottie = true;
  late AnimationController _animationController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat();
    _checkStickerType();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkStickerType() async {
    if (_isDisposed) return;
    
    // Use this local variable for state updates
    bool isLoading = true;
    bool hasError = false;
    bool isLottie = true;

    try {
      // Add a small delay to simulate loading
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In a real scenario, you might want to check if the file exists
      // For now, we'll just use the sticker ID to determine the type
      
      isLoading = false;
      isLottie = true; // Setting to true since we know you have Lottie files
    } catch (e) {
      if (kDebugMode) {
        print('Error checking sticker type: $e');
      }
      isLoading = false;
      hasError = true;
    }

    // Only update state if the widget is still mounted
    if (mounted && !_isDisposed) {
      setState(() {
        _isLoading = isLoading;
        _hasError = hasError;
        _isLottie = isLottie;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedBuilder(
      animation: themeProvider.animation,
      builder: (context, child) {
        final backgroundColor = Color.lerp(
          CupertinoColors.systemGrey6,
          const Color(0xFF161B22),
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemGrey6; 
        
        final iconColor = Color.lerp(
          CupertinoColors.systemGrey,
          CupertinoColors.systemGrey,
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemGrey; 
        
        final textColor = Color.lerp(
          CupertinoColors.black,
          CupertinoColors.white,
          themeProvider.animation.value,
        ) ?? CupertinoColors.black; 
        
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: widget.width,
            height: widget.height,
            // Use null for transparency in Cupertino
            color: null,
            child: _isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : _hasError
                    ? _buildErrorWidget(textColor)
                    : _isLottie
                        ? _buildLottieAnimation()
                        : _buildStaticSticker(textColor),
          ),
        );
      }
    );
  }

  Widget _buildLottieAnimation() {
    return Lottie.asset(
      'assets/stickers/lottie/sticker${widget.stickerId}.json',
      controller: _animationController,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          print('Error loading Lottie animation: $error');
        }
        return _buildStaticSticker(CupertinoColors.white);
      },
    );
  }

  Widget _buildStaticSticker(Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/stickers/preview/sticker${widget.stickerId}.webp',
          width: widget.width * 0.8,
          height: widget.height * 0.8,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            if (kDebugMode) {
              print('Error loading static sticker: $error');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.photo,
                  size: 100,
                  color: CupertinoColors.systemGrey,
                ),
                const SizedBox(height: 16),
                Text(
                  "Static Sticker\n(ID: ${widget.stickerId})",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          "Sticker ID: ${widget.stickerId}",
          style: TextStyle(
            fontSize: 14,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.exclamationmark_circle,
          size: 80,
          color: CupertinoColors.systemRed,
        ),
        const SizedBox(height: 16),
        Text(
          "Failed to load sticker",
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "ID: ${widget.stickerId}",
          style: TextStyle(
            fontSize: 14,
            color: textColor,
          ),
        ),
      ],
    );
  }
}