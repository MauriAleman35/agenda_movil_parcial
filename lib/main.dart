import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/role_provider.dart';
import 'routes/app_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoleProvider()), // Correcto
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
