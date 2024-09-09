import 'dart:math';

String getRandomText() {
  // List of sample text options
  List<String> textOptions = [
    "Nature",
    "Animals",
    "Landscapes",
    "People",
    "Technology",
    "Architecture",
    "Food & Drink",
    "Sports",
    "Fashion",
    "Travel",
    "Art",
    "Cars",
    "Music",
    "Fitness",
    "Health & Wellness",
    "Business",
    "Lifestyle",
    "Workspaces",
    "Portraits",
    "Wildlife",
    "Macro",
    "Cityscapes",
    "Abstract",
    "Flowers",
    "Seasons",
    "Sunset",
    "Mountains",
    "Beaches",
    "Night Sky",
    "Meditation"
  ];
  ;

  // Generate a random index to select text
  Random random = Random();
  int randomIndex = random.nextInt(textOptions.length);

  return textOptions[randomIndex]; // Return random text
}
