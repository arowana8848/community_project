import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/explore/presentation/pages/explore_screen.dart';
import 'package:community/features/addpost/presentation/pages/addpost_screen.dart';
import 'package:community/core/widgets/app_bottom_nav_bar.dart';
import 'package:community/features/feed/presentation/pages/feed_screen.dart';
import 'package:community/features/auth/presentation/provider/auth_provider.dart';
import 'package:community/features/auth/presentation/pages/login_screen.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:community/core/services/storage/user_session_service.dart';
import 'package:community/core/api/api_service.dart';
import 'package:community/core/api/api_endpoint.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFEFF3FF);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  XFile? _pickedImage;
  bool _isUploading = false;
  String? _photoUrl;

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    if (source == ImageSource.camera) {
      var status = await Permission.camera.status;
      if (status.isDenied || status.isRestricted) {
        status = await Permission.camera.request();
      }
      if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Camera permission permanently denied. Please enable it in app settings.'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        return;
      }
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required to take a photo.')),
        );
        return;
      }
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
      await _uploadProfilePicture(pickedFile);
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final userSessionService = ref.read(userSessionServiceProvider);
      final token = await userSessionService.getToken() ?? "";
      final uri = Uri.parse('${ApiEndpoints.baseUrl}/customers/me');
      final response = await http.get(uri, headers: {
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final photoUrl = data['data']?['photoUrl'] ?? data['data']?['profilePicture'];
        setState(() {
          _photoUrl = (photoUrl != null && photoUrl.startsWith('/'))
              ? 'http://10.0.2.2:3000$photoUrl'
              : photoUrl;
        });
      }
    } catch (_) {}
  }

  Future<void> _uploadProfilePicture(XFile imageFile) async {
    setState(() => _isUploading = true);
    try {
      final userSessionService = ref.read(userSessionServiceProvider);
      final token = await userSessionService.getToken() ?? "";
      final response = await uploadProfilePicture(
        imageFile: File(imageFile.path),
        token: token,
        baseUrl: ApiEndpoints.baseUrl,
      );
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated!')),
          );
        }
      } else {
        final respStr = await response.stream.bytesToString();
        print('Upload failed: ${response.statusCode} - $respStr');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload profile picture')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kTopBarColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kPageBgColor,
        appBar: AppBar(
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: kTopBarColor,
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: _pickedImage != null
                                ? FileImage(File(_pickedImage!.path))
                                : (_photoUrl != null
                                  ? NetworkImage(_photoUrl!)
                                  : null),
                              child: (_pickedImage == null && _photoUrl == null)
                                ? const Icon(Icons.person, size: 50, color: Colors.white)
                                : null,
                            ),
                            Positioned(
                              bottom: 6,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                              
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                                    ),
                                    builder: (context) {
                                      return SafeArea(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.camera_alt_outlined),
                                              title: const Text('Take Photo'),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await _pickImage(context, ImageSource.camera);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.photo_library_outlined),
                                              title: const Text('Choose from Gallery'),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await _pickImage(context, ImageSource.gallery);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "username_here",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await ref.read(authProvider.notifier).logout();
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()),
                                  (route) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Logout",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      itemCount: 0, // 🔥 change this to posts.length later
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.blue.shade100,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Icon(Icons.photo_library_outlined,
                      size: 60, color: Colors.black26),
                  const SizedBox(height: 8),
                  const Text(
                    "No posts yet",
                    style: TextStyle(color: Colors.black45),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            if (_isUploading)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(
          selectedIndex: 4,
          onFeed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FeedScreen(),
              ),
            );
          },
          onHome: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
          onCommunities: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExploreScreen(onJoin: (c) {}),
              ),
            );
          },
          onAdd: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPostScreen(),
              ),
            );
          },
          onProfile: null,
        ),
      ),
    );
  }
}