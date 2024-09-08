import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List> fetchapi() async {
  List images = [];
  await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
      headers: {
        'Authorization':
            '2h27BdYLyoPzjPZ2ySXfbaDH2kEBHj8PiuEFaINXMKwvS50dkKvsSQ8F'
      }).then((value) {
    Map res = jsonDecode(value.body);
    images = res['images'];
  });
  return images;
}
