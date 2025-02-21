import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:berht_dev/theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AnimatedBuilder(
      animation: themeProvider.animation,
      builder: (context, child) {
        final backgroundColor = Color.lerp(
          CupertinoColors.systemGrey6,
          const Color(0xFF010409),
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemGrey6; 
        
        final textColor = Color.lerp(
          CupertinoColors.systemGrey,
          const Color(0xFF8b949e),
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemGrey; 
        
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFooterLink('GitHub', 'https://github.com/RobertMeow', 
                  FontAwesomeIcons.github, context, textColor),
              _buildFooterLink('Telegram', 'https://robert_meow.t.me', 
                  CupertinoIcons.paperplane_fill, context, textColor),
            ],
          ),
        );
      }
    );
  }

  Widget _buildFooterLink(String title, String url, IconData icon, BuildContext context, Color textColor) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Icon(
            icon,
            color: textColor,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
      onPressed: () => _launchURL(url, context),
    );
  }

  Future<void> _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }
}