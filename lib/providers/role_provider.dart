import 'package:flutter/material.dart';

class RoleProvider with ChangeNotifier {
  String _role = 'teacher'; // Rol por defecto

  String get role => _role;

  void setRole(String role) {
    _role = role;
    notifyListeners(); // Notifica cambios a la UI
  }
}
