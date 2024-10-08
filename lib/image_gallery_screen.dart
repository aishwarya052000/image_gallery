import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'backend/api_services.dart';

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({super.key});

  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  final PixabayService _pixabayService = PixabayService();
  final ScrollController _scrollController = ScrollController();

  final List<dynamic> _images = [];
  int _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchImages();
      }
    });
  }

  Future<void> _fetchImages() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      List<dynamic> fetchedImages = await _pixabayService.fetchImages(_page);
      setState(() {
        _images.addAll(fetchedImages);
        _page++;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Pixabay Image Gallery')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildImageGrid(),
      ),
    );
  }

  Widget _buildImageGrid() {
    return Stack(
      children: [
        MasonryGridView.count(
          controller: _scrollController,
          crossAxisCount: MediaQuery.of(context).size.width ~/ 180,
          itemCount: _images.length,
          itemBuilder: (BuildContext context, int index) {
            final image = _images[index];
            return _buildImageCard(image);
          },
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        if (_isLoading)
          const Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildImageCard(dynamic image) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Image.network(
                  image['webformatURL'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[800]!,
                          highlightColor: Colors.grey[50]!,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 18),
                    const SizedBox(width: 4),
                    Text('${image['likes']}'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.remove_red_eye, color: Colors.blue, size: 18),
                    const SizedBox(width: 4),
                    Text('${image['views']}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}