import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'main.dart';

typedef HeaderBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  double shrinkOffset,
  );

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                  child: AspectRatio(
                    aspectRatio: 0.01,
                    child: Image.asset('assets/images/gruppo.jpg'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: action == AuthAction.signIn
                    ? const Text('Benvenuto nella tana del piacere, entra a fare un giro!')
                    : const Text('Muoviti coglione'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Accedendo, ogni tuo dato sarà messo a disposizione di Marraccias.inc',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/images/gruppo.jpg'),
                ),
              );
            },
            );
          }
        return MyHomePage();
      }
    );
  }
}
