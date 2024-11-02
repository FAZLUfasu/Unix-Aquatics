// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:unix/LoginPage.dart';
import 'package:unix/galery.dart';
import 'package:unix/settings.dart';

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

class NewsUpdateModel {
  final int id;
  final String title;
  final String description;
  final DateTime datePublished;

  NewsUpdateModel({
    required this.id,
    required this.title,
    required this.description,
    required this.datePublished,
  });

  factory NewsUpdateModel.fromJson(Map<String, dynamic> json) {
    return NewsUpdateModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      datePublished: DateTime.parse(json['date_published']),
    );
  }
}

class SummaryModel {
  final int id;
  final String title;
  final String description;

  SummaryModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
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

  Future<List<NewsUpdateModel>> fetchNewsUpdates() async {
    final response = await http.get(Uri.parse('$baseUrl/app/news/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => NewsUpdateModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news updates');
    }
  }

  Future<List<SummaryModel>> fetchSummaries() async {
    final response = await http.get(Uri.parse('$baseUrl/app/summary/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SummaryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load summaries');
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService('http://13.210.211.177:8000');
  List<ImageModel> images = [];
  List<NewsUpdateModel> newsUpdates = [];
  List<SummaryModel> summaries = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Color> getCardColors() {
    return [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.cyanAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
    ];
  }

  Future<void> fetchData() async {
    try {
      final fetchedImages = await apiService.fetchImages();
      final fetchedNewsUpdates = await apiService.fetchNewsUpdates();
      final fetchedSummaries = await apiService.fetchSummaries();

      setState(() {
        images = fetchedImages;
        newsUpdates = fetchedNewsUpdates;
        summaries = fetchedSummaries;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.image), // Gallery icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GalleryPage()), // Navigate to GalleryPage
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings), // Settings icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage()), // Navigate to SettingsPage
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (images.isNotEmpty)
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200.0,
                            autoPlay: true,
                            enlargeCenterPage: true,
                          ),
                          items: images.map((image) {
                            return GestureDetector(
                              onTap: () {
                                // Navigate to full screen image on single tap
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImagePage(
                                      imageUrls: images
                                          .map((image) => image.url)
                                          .toList(),
                                      initialIndex: images
                                          .indexOf(image), // Get current index
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                image.url,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'News and Updates',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 200, // Adjust height as needed
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: newsUpdates.length,
                                itemBuilder: (context, index) {
                                  final update = newsUpdates[index];
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            update.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(update.description),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Summaries',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              children: summaries.asMap().entries.map((entry) {
                                int index = entry.key;
                                SummaryModel summary = entry.value;
                                List<Color> cardColors = getCardColors();

                                return Card(
                                  color: cardColors[index % cardColors.length],
                                  child: ListTile(
                                    title: Text(summary.title),
                                    subtitle: Text(summary.description),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
