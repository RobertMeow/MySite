import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  AnimationController get animationController => _animationController;
  Animation<double> get animation => _animation;
  bool get isDarkMode => _isDarkMode;

  void initAnimationController(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
      value: _isDarkMode ? 1.0 : 0.0,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    
    if (_isDarkMode) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  CupertinoThemeData get currentTheme => _isDarkMode
      ? const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: CupertinoColors.systemBlue,
          scaffoldBackgroundColor: Color(0xFF010409),
          barBackgroundColor: Color(0xFF161B22),
          textTheme: CupertinoTextThemeData(
            primaryColor: CupertinoColors.white,
            textStyle: TextStyle(
              color: CupertinoColors.white,
              fontFamily: 'SF Pro',
            ),
          ),
        )
      : const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemBlue,
          scaffoldBackgroundColor: CupertinoColors.systemBackground,
          barBackgroundColor: CupertinoColors.systemGrey6,
          textTheme: CupertinoTextThemeData(
            primaryColor: CupertinoColors.black,
            textStyle: TextStyle(
              color: CupertinoColors.black,
              fontFamily: 'SF Pro',
            ),
          ),
        );
}

class AnimatedThemeWidget extends StatefulWidget {
  final Widget child;
  final ThemeProvider themeProvider;

  const AnimatedThemeWidget({
    Key? key,
    required this.child,
    required this.themeProvider,
  }) : super(key: key);

  @override
  State<AnimatedThemeWidget> createState() => _AnimatedThemeWidgetState();
}

class _AnimatedThemeWidgetState extends State<AnimatedThemeWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.themeProvider.initAnimationController(this);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.themeProvider.animation,
      builder: (context, child) {
        final scaffoldBackgroundColor = Color.lerp(
          CupertinoColors.systemBackground,
          const Color(0xFF010409),
          widget.themeProvider.animation.value,
        );

        return Container(color: scaffoldBackgroundColor, child: widget.child);
      },
    );
  }
}
