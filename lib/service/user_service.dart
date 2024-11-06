import 'api_service.dart';

class UserService {
  Future<void> fetchAllUsers() async {
    try {
      final response = await Api.instance.get('/users');
      print('Fetched users: ${response.data}');
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await Api.instance.post(
        '/users',
        data: userData,
      );
      print('User added: ${response.data}');
    } catch (e) {
      print('Error adding user: $e');
    }
  }
}
