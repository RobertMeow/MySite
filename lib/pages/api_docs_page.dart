import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:berht_dev/utils/helpers.dart';
import 'package:berht_dev/theme/app_theme.dart';
import 'package:berht_dev/widgets/link_button.dart';
import 'package:berht_dev/widgets/footer.dart';

class ApiDocsPage extends StatefulWidget {
  const ApiDocsPage({super.key});

  @override
  State<ApiDocsPage> createState() => _ApiDocsPageState();
}

class _ApiDocsPageState extends State<ApiDocsPage> {
  Map<String, dynamic> apiMethods = {};
  final Set<String> expandedMethods = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApiMethods();
  }

  Future<void> _loadApiMethods() async {
    try {
      const jsonString = '''
      {
        "GetStickers": {
          "description": "Get user stickers. Here's how to use it:",
          "code": "import requests\\n\\nurl = \\"https://api.hella.team/method/getStickers\\"\\nparams = {\\n    \\"v\\": \\"2\\",\\n    \\"user_id\\": 1\\n}\\n\\nresp = requests.get(url, params=params)\\nif resp.status_code != 200:\\n    raise Exception(\\"Error: {}\\".format(resp.status_code))\\nprint(resp.json())",
          "output": "{\\n  \\"object\\": {\\n      \\"all_price\\": 10626,\\n      \\"all_price_vote\\": 1518,\\n      \\"count\\": 196,\\n      \\"items\\": {\\n          \\"animation\\": {\\n              \\"count\\": 9,\\n              \\"names\\": [\\n                  \\"Пси-Кот\\",\\n                  \\"Анимированный Сеня\\",\\n                  // ...\\n              ],\\n              \\"price_vote\\": 160\\n          },\\n          \\"free\\": {\\n              \\"count\\": 48,\\n              \\"names\\": [\\n                  \\"Фруктовощи\\",\\n                  \\"Спотти\\",\\n                  // ...\\n              ],\\n              \\"price_vote\\": 0\\n          },\\n          // ...\\n      }\\n  },\\n  \\"ok\\": true\\n}"
        },
        "GetSticker": {
          "description": "Get information about the sticker pack, required parameter access_token",
          "code": "import requests\\n\\nurl = \\"https://api.hella.team/method/getSticker\\"\\nparams = {\\n    \\"v\\": \\"2\\",\\n    \\"sticker_id\\": 1,\\n    \\"product_id\\": 1\\n}\\n\\nresp = requests.get(url, params=params)\\nif resp.status_code != 200:\\n    raise Exception(\\"Error: {}\\".format(resp.status_code))\\nprint(resp.json())",
          "output": "{\\n  \\"object\\": {\\n      \\"author\\": \\"Андрей Яковенко\\",\\n      \\"author_id\\": 11316927,\\n      \\"count\\": 49,\\n      \\"description\\": \\"Чемпион по вилянию хвостом, верный друг и надёжная грелк\\n  а.\\",\\n      \\"is_anim\\": false,\\n      \\"is_new\\": false,\\n      \\"items\\": [\\n          \\"лол\\",\\n          \\"хаха\\",\\n          \\"ахах\\",\\n          // ...\\n      ],\\n      \\"price\\": 0,\\n      \\"style_orig\\": false,\\n      \\"title\\": \\"Спотти\\",\\n      \\"unique\\": false\\n  },\\n  \\"ok\\": true\\n}"
        }
      }
      ''';

      setState(() {
        apiMethods = json.decode(jsonString);
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading API methods: $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleMethod(String methodName) {
    if (mounted) {
      setState(() {
        if (expandedMethods.contains(methodName)) {
          expandedMethods.remove(methodName);
        } else {
          expandedMethods.add(methodName);
        }
      });
    }
  }

  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showCupertinoSnackBar(context: context, message: 'Copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedBuilder(
      animation: themeProvider.animation,
      builder: (context, child) {
        final backgroundColor = Color.lerp(
          CupertinoColors.systemBackground,
          const Color(0xFF161B22),
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemBackground; 
        
        final textColor = Color.lerp(
          CupertinoColors.black,
          CupertinoColors.white,
          themeProvider.animation.value,
        ) ?? CupertinoColors.black; 
        
        final greyTextColor = Color.lerp(
          CupertinoColors.systemGrey,
          const Color(0xFF8b949e),
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemGrey; 
        
        final codeBackgroundColor = Color.lerp(
          CupertinoColors.systemGrey6,
          const Color(0xFF161B22),
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemGrey6; 
        
        final dividerColor = Color.lerp(
          CupertinoColors.systemGrey5,
          const Color(0xFF30363D),
          themeProvider.animation.value,
        ) ?? CupertinoColors.systemGrey5; 
        
        final backButtonColor = Color.lerp(
          CupertinoColors.black,
          CupertinoColors.white,
          themeProvider.animation.value,
        ) ?? CupertinoColors.black; 

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('API Documentation'),
            backgroundColor: backgroundColor,
            leading: CupertinoNavigationBarBackButton(
              onPressed: () => Navigator.pop(context),
              color: backButtonColor,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: isLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Welcome to my little API documentation. Below you will find a list of available API methods and examples of their use.',
                            style: TextStyle(
                              color: greyTextColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Endpoint',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Our API endpoint is located at',
                            style: TextStyle(
                              color: greyTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => copyText('https://api.berht.dev'),
                            child: Text(
                              'https://api.berht.dev',
                              style: TextStyle(
                                fontFamily: 'Courier',
                                backgroundColor: codeBackgroundColor,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                          Text(
                            'At the moment, the most up-to-date version of the API==2',
                            style: TextStyle(
                              color: greyTextColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Authentication',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'For authorization, you must specify',
                            style: TextStyle(
                              color: greyTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => copyText('access_token'),
                            child: Text(
                              'access_token',
                              style: TextStyle(
                                fontFamily: 'Courier',
                                backgroundColor: codeBackgroundColor,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'as a parameter, you can get it ',
                                style: TextStyle(
                                  color: greyTextColor,
                                ),
                              ),
                              const LinkButton(
                                title: 'here',
                                url: 'https://vk.com/im?sel=-210709215',
                                textVer: true,
                              ),
                            ],
                          ),
                          Text(
                            'If you do not specify',
                            style: TextStyle(
                              color: greyTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => copyText('access_token'),
                            child: Text(
                              'access_token',
                              style: TextStyle(
                                fontFamily: 'Courier',
                                backgroundColor: codeBackgroundColor,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                          Text(
                            ', then the limits will be very strict.',
                            style: TextStyle(
                              color: greyTextColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'API Methods',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...apiMethods.entries.map((entry) {
                            final methodName = entry.key;
                            final methodData = entry.value;
                            final isExpanded = expandedMethods.contains(methodName);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          methodName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        Icon(
                                          isExpanded
                                              ? CupertinoIcons.chevron_up
                                              : CupertinoIcons.chevron_down,
                                          color: textColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () => toggleMethod(methodName),
                                ),
                                if (isExpanded) ...[
                                  Text(
                                    methodData['description'],
                                    style: TextStyle(
                                      color: greyTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: codeBackgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              child: Icon(
                                                CupertinoIcons.doc_on_clipboard,
                                                color: textColor,
                                                size: 20,
                                              ),
                                              onPressed:
                                                  () => copyText(methodData['code']),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          methodData['code'],
                                          style: TextStyle(
                                            fontFamily: 'Courier',
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Output:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: codeBackgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              child: Icon(
                                                CupertinoIcons.doc_on_clipboard,
                                                color: textColor,
                                                size: 20,
                                              ),
                                              onPressed:
                                                  () =>
                                                      copyText(methodData['output']),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          methodData['output'],
                                          style: TextStyle(
                                            fontFamily: 'Courier',
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                SizedBox(
                                  height: 1,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: dividerColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          Text(
                            'More methods will be added soon.',
                            style: TextStyle(
                              color: greyTextColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 32),
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
}