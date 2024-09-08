import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

class ImageFullscreen extends StatefulWidget {
  final String imagepath;

  const ImageFullscreen({super.key, required this.imagepath});

  @override
  State<ImageFullscreen> createState() => _ImageFullscreenState();
}

class _ImageFullscreenState extends State<ImageFullscreen> {
  bool isLiked = false; // To track if the image is liked

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? likedImages = prefs.getStringList('likedImages') ?? [];
    if (likedImages.contains(widget.imagepath)) {
      setState(() {
        isLiked = true;
      });
    }
  }

  Future<void> _toggleLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> likedImages = prefs.getStringList('likedImages') ?? [];

    setState(() {
      isLiked = !isLiked;
    });

    if (isLiked) {
      likedImages.add(widget.imagepath); // Add image to liked list
    } else {
      likedImages.remove(widget.imagepath); // Remove image from liked list
    }

    await prefs.setStringList('likedImages', likedImages);
  }

  Future<void> setWallpaperHomescreen() async {
    int loc = WallpaperManager.HOME_SCREEN;

    try {
      File file = await DefaultCacheManager().getSingleFile(widget.imagepath);

      // Get screen dimensions
      int width = MediaQuery.of(context).size.width.toInt();
      int height = MediaQuery.of(context).size.height.toInt();

      // Load and resize the image
      img.Image? image = img.decodeImage(file.readAsBytesSync());
      if (image != null) {
        img.Image resizedImage =
            img.copyResize(image, width: width, height: height);
        File resizedFile = File('${file.path}_resized.jpg')
          ..writeAsBytesSync(img.encodeJpg(resizedImage));

        // Set wallpaper using the resized image
        bool result =
            await WallpaperManager.setWallpaperFromFile(resizedFile.path, loc);

        // Show success or failure message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result
                ? 'Wallpaper set successfully!'
                : 'Failed to set wallpaper')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> setWallpaperLockscreen() async {
    int loc = WallpaperManager.LOCK_SCREEN;

    try {
      File file = await DefaultCacheManager().getSingleFile(widget.imagepath);

      // Get screen dimensions
      int width = MediaQuery.of(context).size.width.toInt();
      int height = MediaQuery.of(context).size.height.toInt();

      // Load and resize the image
      img.Image? image = img.decodeImage(file.readAsBytesSync());
      if (image != null) {
        img.Image resizedImage =
            img.copyResize(image, width: width, height: height);
        File resizedFile = File('${file.path}_resized.jpg')
          ..writeAsBytesSync(img.encodeJpg(resizedImage));

        // Set wallpaper using the resized image
        bool result =
            await WallpaperManager.setWallpaperFromFile(resizedFile.path, loc);

        // Show success or failure message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result
                ? 'Wallpaper set successfully!'
                : 'Failed to set wallpaper')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> setWallpaperBothScreens() async {
    int loc = WallpaperManager.BOTH_SCREEN;

    try {
      File file = await DefaultCacheManager().getSingleFile(widget.imagepath);

      // Get screen dimensions
      int width = MediaQuery.of(context).size.width.toInt();
      int height = MediaQuery.of(context).size.height.toInt();

      // Load and resize the image
      img.Image? image = img.decodeImage(file.readAsBytesSync());
      if (image != null) {
        img.Image resizedImage =
            img.copyResize(image, width: width, height: height);
        File resizedFile = File('${file.path}_resized.jpg')
          ..writeAsBytesSync(img.encodeJpg(resizedImage));

        // Set wallpaper using the resized image
        bool result =
            await WallpaperManager.setWallpaperFromFile(resizedFile.path, loc);

        // Show success or failure message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result
                ? 'Wallpaper set successfully!'
                : 'Failed to set wallpaper')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.network(
                widget.imagepath,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.3),
            ),
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width / 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          elevation: 8,
                        ),
                        onPressed: setWallpaperHomescreen,
                        child: Text(
                          'Home Screen',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          elevation: 8,
                        ),
                        onPressed: setWallpaperLockscreen,
                        child: Text(
                          'Lock Screen',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          elevation: 8,
                        ),
                        onPressed: setWallpaperBothScreens,
                        child: Text(
                          'Both Screen',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.white,
                  size: 40,
                ),
                onPressed: _toggleLike,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallpaperButton(String label, VoidCallback onPressed) {
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
          elevation: 8,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
