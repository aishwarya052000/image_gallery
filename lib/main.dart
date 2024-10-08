import 'package:flutter/material.dart';
import 'image_gallery_screen.dart';

void main() {
  runApp(const PixabayGalleryApp());
}

class PixabayGalleryApp extends StatelessWidget {
  const PixabayGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixabay Gallery',
      theme: ThemeData.dark(),
      home: const ImageGalleryScreen(),
    );
  }
}
