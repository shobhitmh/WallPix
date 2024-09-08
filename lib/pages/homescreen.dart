import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wallpaperapp/pages/imagefullscreen.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/pages/likeimages.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List images = [];
  int page = 1;
  bool isLoadingMore = false;
  String query = "Tigers"; // Default query
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchapi();

    // Attach a listener to the scroll controller
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        loadmore(); // Trigger load more when the user reaches the bottom
      }
    });
  }

  fetchapi() async {
    setState(() {
      page = 1; // Reset page to 1 on a new search
      images = []; // Clear old images
      isLoadingMore = true;
    });

    await http.get(
      Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=80'),
      headers: {
        'Authorization':
            '2h27BdYLyoPzjPZ2ySXfbaDH2kEBHj8PiuEFaINXMKwvS50dkKvsSQ8F',
      },
    ).then((value) {
      Map res = jsonDecode(value.body);
      setState(() {
        images = res['photos'];
        isLoadingMore = false;
      });
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
      isLoadingMore = true;
    });

    String url =
        'https://api.pexels.com/v1/search?query=$query&per_page=80&page=$page';
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '2h27BdYLyoPzjPZ2ySXfbaDH2kEBHj8PiuEFaINXMKwvS50dkKvsSQ8F'
    }).then((value) {
      Map res = jsonDecode(value.body);
      setState(() {
        images.addAll(res['photos']);
        isLoadingMore = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose(); // Dispose of controllers
    super.dispose();
  }

  // Function to handle search when the user submits a query
  void searchImages() {
    setState(() {
      query = _searchController.text.trim(); // Update query with user input
    });
    fetchapi(); // Fetch images based on the new query
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Light background color
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LikedImagesScreen()));
                    },
                    child: Icon(
                      Icons.favorite_border,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        style: TextStyle(
                            color: const Color.fromARGB(255, 27, 26, 26)),
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Search for wallpapers",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        onSubmitted: (value) {
                          searchImages(); // Call search when the user hits "Enter"
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        searchImages(); // Trigger search on button press
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: images.isEmpty && !isLoadingMore
                  ? const Center(
                      child: Text("No images found",
                          style:
                              TextStyle(fontSize: 18, color: Colors.black54)))
                  : GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(10),
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageFullscreen(
                                imagepath: images[index]['src']['large2x'],
                              ),
                            ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              images[index]['src']['tiny'],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
