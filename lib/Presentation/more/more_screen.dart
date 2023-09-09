import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:catch_it_project/Presentation/address_screen/address_screen.dart';
import 'package:catch_it_project/Presentation/login_page.dart';
import 'package:catch_it_project/Presentation/more/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../constants/size_color_constants.dart';
import '../../domain/firebase/firebase_auth.dart';

class MoreScreen extends StatelessWidget {
  MoreScreen({super.key});
  final FirebaseAuthentication firebaseAuth = FirebaseAuthentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              ListTile(
                title: const Text('Account'),
                leading: const Icon(Icons.account_circle),
                onTap: () {
                  // Navigate to account settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountBody()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Address'),
                leading: const Icon(Icons.location_city),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddresScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Privacy'),
                leading: const Icon(Icons.lock),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Terms and conditions'),
                leading: const Icon(Icons.lock),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.lock),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Do you want to Logout"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No')),
                          TextButton(
                              onPressed: () async {
                                showLogoutProgressDialog(context);
                                await firebaseAuth.signOut();
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text("Yes"))
                        ],
                      );
                    },
                  );
                },
              ),
              tSizedBoxHeight100,
              Center(
                child: SizedBox(
                  // width: 250.0,
                  child: AnimatedTextKit(
                    repeatForever: false,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'CatchIt',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        'CatchIt',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        'CatchIt',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showLogoutProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
      ),
      body: const Center(
        child: Text('Notification preferences content goes here'),
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: Future.delayed(const Duration(microseconds: 150)).then(
                    (value) =>
                        rootBundle.loadString('assets/privacypolicy.md')),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                        styleSheet: MarkdownStyleSheet.fromTheme(
                          ThemeData(
                            textTheme: const TextTheme(
                              bodyMedium: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 15.0,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        data: snapshot.data!);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: Future.delayed(const Duration(microseconds: 150)).then(
                    (value) =>
                        rootBundle.loadString('assets/termsandconditions.md')),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                        styleSheet: MarkdownStyleSheet.fromTheme(
                          ThemeData(
                            textTheme: const TextTheme(
                              bodyMedium: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 15.0,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        data: snapshot.data!);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
