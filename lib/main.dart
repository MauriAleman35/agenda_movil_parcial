import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/role_provider.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoleProvider()), // Correcto
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.login, // Ruta inicial
      onGenerateRoute: AppRoutes.generateRoute, // Generador de rutas
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
