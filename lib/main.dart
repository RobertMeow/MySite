import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:berht_dev/theme/app_theme.dart';
import 'package:berht_dev/pages/home_page.dart';
import 'package:berht_dev/pages/api_docs_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.initAnimationController(this);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AnimatedBuilder(
      animation: themeProvider.animation,
      builder: (context, child) {
        final scaffoldBackgroundColor = Color.lerp(
          CupertinoColors.systemBackground,
          const Color(0xFF010409),
          themeProvider.animation.value,
        )!;
        
        final barBackgroundColor = Color.lerp(
          CupertinoColors.systemBackground,
          const Color(0xFF161B22),
          themeProvider.animation.value,
        )!;
        
        final textColor = Color.lerp(
          CupertinoColors.black,
          CupertinoColors.white,
          themeProvider.animation.value,
        )!;
        
        final blendedTheme = CupertinoThemeData(
          brightness: themeProvider.animation.value > 0.5 ? Brightness.dark : Brightness.light,
          primaryColor: CupertinoColors.systemBlue,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          barBackgroundColor: barBackgroundColor,
          textTheme: CupertinoTextThemeData(
            primaryColor: textColor,
            textStyle: TextStyle(
              color: textColor,
              fontFamily: 'SF Pro',
            ),
          ),
        );
        
        return CupertinoApp(
          title: 'My Business Card',
          theme: blendedTheme,
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/api-docs': (context) => const ApiDocsPage(),
          },
        );
      },
    );
  }
}