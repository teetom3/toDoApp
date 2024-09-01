import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/register_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Flutter To-Do App',
            theme: ThemeData(
              primarySwatch: Colors.teal,
              scaffoldBackgroundColor: Colors.grey[200],
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .orange, // Nouvelle syntaxe pour la couleur de fond du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Boutons arrondis
                  ),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors
                      .teal, // Nouvelle syntaxe pour la couleur du texte du bouton
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            home: auth.isAuthenticated ? TaskListScreen() : LoginScreen(),
            routes: {
              '/login': (context) => LoginScreen(),
              '/tasks': (context) => TaskListScreen(),
              '/register': (context) => RegisterScreen(),
            },
          );
        },
      ),
    );
  }
}
