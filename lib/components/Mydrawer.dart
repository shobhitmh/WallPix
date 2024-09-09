import 'package:flutter/material.dart';
import 'package:wallpaperapp/pages/likeimages.dart';
import 'package:wallpaperapp/pages/settings.dart';
import 'package:wallpaperapp/components/Mytiles.dart';
import 'package:wallpaperapp/pages/homescreen.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Icon(
            Icons.wallpaper_sharp,
            size: 200,
            color: theme.iconTheme.color, // Use theme's icon color
          ),
          Text(
            'WallPix',
            style: TextStyle(
                fontSize: 40,
                color:
                    theme.textTheme.headline6?.color), // Use theme's text color
          ),
          Divider(
            thickness: 5,
            indent: 20,
            endIndent: 20,
            color: theme.dividerColor, // Use theme's divider color
          ),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Homescreen(onThemeChanged: (bool value) {})));
              },
              child: Mytiles(text: 'H O M E')),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LikedImagesScreen()));
              },
              child: Mytiles(text: 'L I K E S')),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage(onThemeChanged: (bool value) {})));
              },
              child: Mytiles(text: 'S E T T I N G S')),
        ],
      ),
    );
  }
}
