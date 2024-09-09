import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:wallpaperapp/pages/imagefullscreen.dart';

class LikedImagesScreen extends StatefulWidget {
  @override
  _LikedImagesScreenState createState() => _LikedImagesScreenState();
}

class _LikedImagesScreenState extends State<LikedImagesScreen> {
  List<String> likedImages = [];

  @override
  void initState() {
    super.initState();
    _loadLikedImages();
  }

  Future<void> _loadLikedImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      likedImages = prefs.getStringList('likedImages') ?? [];
    });
  }

  void _shareImage(String imageUrl) {
    Share.share(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine AppBar colors based on the current theme mode
    final appBarBackgroundColor =
        theme.brightness == Brightness.dark ? Colors.black : Colors.white;

    final appBarTextColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: appBarTextColor,
          ),
        ),
        title: Text(
          'L I K E S',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: appBarTextColor),
        ),
        centerTitle: true,
        backgroundColor: appBarBackgroundColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                appBarBackgroundColor,
                appBarBackgroundColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: likedImages.isEmpty
          ? Center(
              child: Text(
                'No liked images yet!',
                style: TextStyle(
                  fontSize: 18,
                  color: theme.textTheme.bodyText1?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: likedImages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _shareImage(likedImages[index]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ImageFullscreen(
                                      imagepath: likedImages[index])));
                            },
                            child: Image.network(
                              likedImages[index],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: theme.progressIndicatorTheme.color,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.share,
                                  color: appBarTextColor,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Share',
                                  style: TextStyle(
                                    color: appBarTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
