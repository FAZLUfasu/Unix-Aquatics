// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageModel {
  final int id;
  final String url;
  final String imagename;
  final String uploaded_at;

  ImageModel({
    required this.id,
    required this.url,
    required this.imagename,
    required this.uploaded_at,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      url: json['image'],
      imagename: json['imagename'],
      uploaded_at: json['uploaded_at'],
    );
  }
}

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<ImageModel>> fetchImages() async {
    final response = await http.get(Uri.parse('$baseUrl/app/up/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ImageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ApiService apiService = ApiService('http://13.210.211.177:8000');
  List<ImageModel> images = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      final fetchedImages = await apiService.fetchImages();
      setState(() {
        images = fetchedImages;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(
                              imageUrls: images
                                  .map((image) => image.url)
                                  .toList(), // Pass correct list of URLs
                              initialIndex: index, // Pass the current index
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    images[index].url,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.broken_image, size: 50),
                                  ),
                                ),
                              ),
                              if (images[index].imagename.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    images[index].imagename,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final List<String> imageUrls; // List of image URLs
  final int initialIndex; // Index of the initial image

  FullScreenImagePage({required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Image'),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove the elevation/shadow
      ),
      body: PageView.builder(
        itemCount: imageUrls.length, // Total number of images
        controller: PageController(
            initialPage: initialIndex), // Start at the selected image
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width, // Full width
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height, // Full height minus AppBar
            child: InteractiveViewer(
              boundaryMargin:
                  EdgeInsets.all(0), // Allow panning beyond the edges
              minScale: 0.1, // Minimum scale factor for zooming out
              maxScale: 4.0, // Maximum scale factor for zooming in
              child: ClipRect(
                // Ensure the image is clipped within bounds
                child: Image.network(
                  imageUrls[index], // Load the image at the current index
                  fit: BoxFit.cover, // Cover the entire screen area
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 100), // Error placeholder
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
