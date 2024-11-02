// // api_service.dart

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:unix/HomePagemedel.dart';

// class ApiService {
//   final String baseUrl;

//   ApiService(this.baseUrl);

//   Future<List<ImageModel>> fetchImages() async {
//     final response = await http.get(Uri.parse('13.210.211.177/images/'));

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.map((json) => ImageModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load images');
//     }
//   }

//   Future<List<NotificationModel>> fetchNotifications() async {
//     final response = await http.get(Uri.parse('13.210.211.177/notifications/'));

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.map((json) => NotificationModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load notifications');
//     }
//   }

//   Future<List<NewsUpdateModel>> fetchNewsUpdates() async {
//     final response = await http.get(Uri.parse('13.210.211.177/news_updates/'));

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.map((json) => NewsUpdateModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load news updates');
//     }
//   }

//   Future<SummaryModel> fetchSummary() async {
//     final response = await http.get(Uri.parse('13.210.211.177/summary/'));

//     if (response.statusCode == 200) {
//       return SummaryModel.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load summary');
//     }
//   }
// }
