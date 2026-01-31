import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.StreamedResponse> uploadProfilePicture({
  required File imageFile,
  required String token,
  required String baseUrl, // e.g., 'http://10.0.2.2:3000/community'
}) async {
  final uri = Uri.parse('$baseUrl/customers/profile-picture');
  final request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = 'Bearer $token';
  request.files.add(await http.MultipartFile.fromPath('profilePicture', imageFile.path));
  return await request.send();
}
