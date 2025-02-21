import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

import 'package:berht_dev/theme/app_theme.dart';
import 'package:berht_dev/widgets/footer.dart';
import 'package:berht_dev/widgets/link_button.dart';
import 'package:berht_dev/widgets/sticker_animation.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _showLinks = false;
  final int stickerId = math.Random().nextInt(58220 - 58173) + 58173;
  
  // Animation controller for the links section
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    
    // Create a fade animation that stays within valid bounds (0.0 to 1.0)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    
    // Create a slide animation for a smooth entrance
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // Toggle links with animation
  void _toggleLinks() {
    setState(() {
      _showLinks = !_showLinks;
      
      if (_showLinks) {
        _animationController.forward(from: 0.0);
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AnimatedBuilder(
      animation: themeProvider.animation,
      builder: (context, child) {
        final containerColor = Color.lerp(
          CupertinoColors.systemGrey6,
          const Color(0xFF161B22),
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemGrey6; 
        
        final textColor = Color.lerp(
          CupertinoColors.black,
          CupertinoColors.white,
          themeProvider.animation.value,
        ) ?? CupertinoColors.black; 
        
        final navBarColor = Color.lerp(
          CupertinoColors.systemBackground,
          const Color(0xFF161B22),
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemBackground; 

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              'My Business Card',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: navBarColor,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isDark ? CupertinoIcons.sun_max : CupertinoIcons.moon,
                  key: ValueKey<bool>(isDark),
                  color: textColor,
                ),
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "I am a backend developer with experience in Python, C++, and SQL. I have worked on a variety of projects ranging from REST APIs to data processing pipelines. My goal is to build scalable and reliable systems that can handle high volumes of traffic and data.",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            
                            // Apple-style animation with simpler, more stable implementation
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: Curves.easeOutBack,
                              switchOutCurve: Curves.easeInBack,
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: _showLinks
                                  ? _buildLinks()
                                  : _buildUsefulButton(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        height: 352,
                        alignment: Alignment.center,
                        child: StickerAnimation(stickerId: stickerId),
                      ),
                    ],
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        );
      }
    );
  }
  
  // Button widget with key for AnimatedSwitcher
  Widget _buildUsefulButton() {
    return CupertinoButton(
      key: const ValueKey<String>('useful_button'),
      padding: EdgeInsets.zero,
      onPressed: _toggleLinks,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              CupertinoColors.activeBlue,
              CupertinoColors.systemIndigo,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Text(
          'Useful',
          style: TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  // Links widget with animation and key for AnimatedSwitcher
  Widget _buildLinks() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              key: const ValueKey<String>('links_column'),
              children: const [
                LinkButton(
                  title: 'API Documentation',
                  url: '/api-docs',
                ),
                SizedBox(height: 8),
                LinkButton(
                  title: 'Getting VKToken',
                  url: 'https://github.com/RobertMeow/VKTokenMaster/releases/tag/v1.0.0%2B1.31',
                ),
                SizedBox(height: 8),
                LinkButton(
                  title: 'Donate',
                  url: 'https://www.tinkoff.ru/cf/3Tkl3awpS5c',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}