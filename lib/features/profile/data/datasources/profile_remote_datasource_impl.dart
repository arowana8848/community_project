import 'dart:convert';
import 'dart:io';
import 'package:community/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:community/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:community/core/api/api_endpoint.dart';
import 'package:http/http.dart' as http;

class ProfileRemoteDatasourceImpl implements IProfileRemoteDatasource {
  @override
  Future<ProfileEntity?> fetchProfile(String token, String customerId) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}/customers/$customerId');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
        },
      );
      if (response.statusCode == 200) {
        final data = response.body;
        final json = jsonDecode(data);
        final profileData = json['data'] ?? json;
        final normalizedPhotoUrl = _normalizePhotoUrl(
          profileData['profilePictureUrl'] ??
              profileData['profilePicture'] ??
              profileData['photoUrl'],
        );
        return ProfileEntity(
          id: profileData['_id']?.toString() ?? profileData['id']?.toString(),
          name: profileData['name'],
          email: profileData['email'],
          photoUrl: normalizedPhotoUrl,
        );
      } else {
        debugPrint('Fetch profile failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Fetch profile error: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<bool> uploadProfilePicture(File imageFile, String token, String customerId) async {
    try {
      var uri = Uri.parse('${ApiEndpoints.baseUrl}/customers/$customerId/profile-picture');
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath('photo', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        debugPrint('Upload successful');
        return true;
      } else {
        debugPrint('Upload failed: ${response.statusCode}');
        final respStr = await response.stream.bytesToString();
        debugPrint('Response body: $respStr');
        return false;
      }
    } catch (e) {
      debugPrint('Upload error: ${e.toString()}');
      return false;
    }
  }

  String? _normalizePhotoUrl(dynamic rawUrl) {
    if (rawUrl == null) {
      return null;
    }
    final url = rawUrl.toString().trim();
    if (url.isEmpty) {
      return null;
    }
    final parsed = Uri.tryParse(url);
    if (parsed != null && parsed.hasScheme) {
      return url;
    }

    final base = Uri.parse(ApiEndpoints.baseUrl);
    if (url.startsWith('/')) {
      return '${base.origin}$url';
    }

    return '${ApiEndpoints.baseUrl}/$url';
  }
}
