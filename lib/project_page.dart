// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unix/myprojectpage.dart';
import 'package:unix/projectdetails_page.dart';
import 'package:unix/videogalery.dart';
import 'package:video_player/video_player.dart';

class ProjectModel {
  final int id;
  final String proname;
  final String description;
  final String projectlogo;
  final String prologoname;
  final DateTime startDate;
  final DateTime dateOfEstablishment;
  final String location;
  final int numberOfPonds;
  final double waterCapacity;
  final double annualProductionCapacity;
  final String capital;
  final int numberOfShares;
  final String pricePerShare;

  ProjectModel({
    required this.id,
    required this.proname,
    required this.description,
    required this.projectlogo,
    required this.prologoname,
    required this.startDate,
    required this.dateOfEstablishment,
    required this.location,
    required this.numberOfPonds,
    required this.waterCapacity,
    required this.annualProductionCapacity,
    required this.capital,
    required this.numberOfShares,
    required this.pricePerShare,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      proname: json['proname'],
      description: json['description'] ?? '',
      projectlogo: json['projectlogo'],
      prologoname: json['prologoname'],
      startDate: DateTime.parse(json['start_date']),
      dateOfEstablishment: DateTime.parse(json['date_of_establishment']),
      location: json['location'],
      numberOfPonds: json['number_of_ponds'],
      waterCapacity: json['water_capacity'].toDouble(),
      annualProductionCapacity: json['annual_production_capacity'].toDouble(),
      capital: json['capital'],
      numberOfShares: json['number_of_shares'],
      pricePerShare: json['price_per_share'],
    );
  }
}

class VideoModel {
  final int id;
  final String url;
  final String videoname;
  final DateTime? dateOfUpload;

  VideoModel({
    required this.id,
    required this.url,
    required this.videoname,
    this.dateOfUpload,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      url: json['video'] ?? '',
      videoname: json['videoname'] ?? 'unknown.mp4',
      dateOfUpload: json['date_of_upload'] != null
          ? DateTime.parse(json['date_of_upload'])
          : null,
    );
  }
}

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<VideoModel>> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/app/videos/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<ProjectModel>> fetchProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/app/Projectpage/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      return [];
    }
  }
}

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final ApiService apiService = ApiService('http://13.210.211.177:8000');
  List<VideoModel> videos = [];
  List<ProjectModel> projects = [];
  int _current = 0;
  List<VideoPlayerController> _controllers = [];
  List<bool> _isPlaying = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final fetchedVideos = await apiService.fetchVideos();
    final fetchedProjects = await apiService.fetchProjects();
    setState(() {
      videos = fetchedVideos;
      projects = fetchedProjects;

      _controllers = videos.map((video) {
        // ignore: deprecated_member_use
        final controller = VideoPlayerController.network(video.url)
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
        return controller;
      }).toList();
      _isPlaying = List<bool>.filled(videos.length, false);
    });
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _togglePlayPause(int index) {
    setState(() {
      if (_isPlaying[index]) {
        _controllers[index].pause();
      } else {
        _controllers.forEach((controller) => controller.pause());
        _controllers[index].play();
      }
      _isPlaying = List<bool>.filled(videos.length, false);
      _isPlaying[index] = !_isPlaying[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.video_file), // Gallery icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VideoGalleryPage()), // Navigate to GalleryPage
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_box),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProjectPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Carousel
          if (videos.isNotEmpty)
            Expanded(
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      if (_controllers.isNotEmpty) {
                        _controllers[_current].pause();
                        _isPlaying[_current] = false;
                      }
                      _current = index;
                    });
                  },
                ),
                itemCount: videos.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  final controller = _controllers[itemIndex];
                  return controller.value.isInitialized
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenVideoPage(
                                  videoUrl: videos[itemIndex].url,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: VideoPlayer(controller),
                              ),
                              if (!_isPlaying[itemIndex])
                                IconButton(
                                  icon: Icon(Icons.play_arrow,
                                      size: 50, color: Colors.white),
                                  onPressed: () => _togglePlayPause(itemIndex),
                                ),
                            ],
                          ),
                        )
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),

          // Project Cards
          Expanded(
            child: ListView(
              children: [
                ...projects.map((project) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: project.projectlogo.isNotEmpty
                          ? Image.network(
                              'http://13.210.211.177:8000${project.projectlogo}',
                              width: 60,
                            )
                          : null,
                      title: Text(project.proname),
                      subtitle: Text(project.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailsPage(
                              id: project.id,
                              proname: project.proname,
                              description: project.description,
                              projectlogo: project.projectlogo,
                              prologoname: project.prologoname,
                              startDate: project.startDate,
                              dateOfEstablishment: project.dateOfEstablishment,
                              location: project.location,
                              numberOfPonds: project.numberOfPonds,
                              waterCapacity: project.waterCapacity,
                              annualProductionCapacity:
                                  project.annualProductionCapacity,
                              capital: project.capital,
                              numberOfShares: project.numberOfShares,
                              pricePerShare: project.pricePerShare,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPage({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        // Lock the orientation to landscape when the video starts playing
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ]);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    // Restore the device orientation when leaving the page
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
