import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkButton extends StatelessWidget {
  final String title;
  final String url;
  final bool textVer;
  final IconData? icon;
  
  const LinkButton({
    super.key,
    required this.title,
    required this.url,
    this.textVer = false,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    if (textVer) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: CupertinoColors.activeBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: CupertinoColors.activeBlue,
              ),
            ),
          ],
        ),
        onPressed: () {
          if (url.startsWith('http')) {
            _launchURL(url);
          } else {
            Navigator.of(context).pushNamed(url);
          }
        },
      );
    }
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: CupertinoTheme.of(context).primaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      onPressed: () {
        if (url.startsWith('http')) {
          _launchURL(url);
        } else {
          Navigator.of(context).pushNamed(url);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: CupertinoTheme.of(context).primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: TextStyle(
              color: CupertinoTheme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }
}