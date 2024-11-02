// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class ProjectDetailsPage extends StatefulWidget {
//   final int id;
//   final String proname;
//   final String description;
//   final String projectlogo;
//   final String prologoname;
//   final DateTime startDate;
//   final DateTime dateOfEstablishment;
//   final String location;
//   final int numberOfPonds;
//   final double waterCapacity;
//   final double annualProductionCapacity;
//   final String capital;
//   final int numberOfShares;
//   final String pricePerShare;

//   ProjectDetailsPage({
//     required this.id,
//     required this.proname,
//     required this.description,
//     required this.projectlogo,
//     required this.prologoname,
//     required this.startDate,
//     required this.dateOfEstablishment,
//     required this.location,
//     required this.numberOfPonds,
//     required this.waterCapacity,
//     required this.annualProductionCapacity,
//     required this.capital,
//     required this.numberOfShares,
//     required this.pricePerShare,
//   });

//   @override
//   _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
// }

// class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
//   bool isLoading = true;
//   bool isRequestingJoin = false;
//   final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
//   final storage = FlutterSecureStorage();
//   String? username;
//   List<dynamic> joinRequests = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsername(); // Fetch username when the page initializes
//     _fetchJoinRequests(); // Fetch join requests when the page initializes
//     _fetchProjectDetails(); // Simulate fetching project details
//   }

//   Future<void> _fetchUsername() async {
//     final user = await storage.read(key: 'username');
//     setState(() {
//       username = user;
//     });
//   }

//   void _fetchProjectDetails() {
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   Future<void> _fetchJoinRequests() async {
//     final url = Uri.parse('http://13.210.211.177:8000/app/join-table/');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       setState(() {
//         joinRequests = json.decode(response.body); // Parse the response body
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load join requests.')),
//       );
//     }
//   }

//   Future<void> _sendJoinRequest() async {
//     if (username == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('You need to log in to send a join request.')),
//       );
//       return;
//     }

//     // Check if the join request already exists
//     bool requestExists = joinRequests.any((request) =>
//         request['username'] == username &&
//         request['projectname'] == widget.proname);

//     if (requestExists) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Join request already sent for this project.')),
//       );
//       return; // Exit the function if the request exists
//     }

//     // Create a new join request object
//     final newJoinRequest = {
//       'username': username,
//       'projectname': widget.proname,
//       // Add any additional properties if needed
//     };

//     // Simulate adding the join request to the local list
//     setState(() {
//       joinRequests.add(newJoinRequest); // Add the new request locally
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Join request sent successfully!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.proname),
//       ),
//       body: SafeArea(
//         child: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Center(
//                     child: Card(
//                       elevation: 4.0,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (widget.projectlogo.isNotEmpty)
//                               Center(
//                                 child: Image.network(
//                                   'http://13.210.211.177:8000${widget.projectlogo}',
//                                   width: 170,
//                                   height: 200,
//                                 ),
//                               ),
//                             SizedBox(height: 16.0),
//                             Text(
//                               'Name: ${widget.proname}',
//                               style: Theme.of(context).textTheme.titleLarge,
//                             ),
//                             SizedBox(height: 8.0),
//                             Text('Description: ${widget.description}'),
//                             SizedBox(height: 8.0),
//                             Text(
//                                 'Start Date: ${dateFormat.format(widget.startDate)}'),
//                             SizedBox(height: 8.0),
//                             Text(
//                                 'Date of Establishment: ${dateFormat.format(widget.dateOfEstablishment)}'),
//                             SizedBox(height: 8.0),
//                             Text('Location: ${widget.location}'),
//                             SizedBox(height: 8.0),
//                             Text('Number of Ponds: ${widget.numberOfPonds}'),
//                             SizedBox(height: 8.0),
//                             Text('Water Capacity: ${widget.waterCapacity}'),
//                             SizedBox(height: 8.0),
//                             Text(
//                                 'Annual Production Capacity: ${widget.annualProductionCapacity}'),
//                             SizedBox(height: 8.0),
//                             Text('Capital: ${widget.capital}'),
//                             SizedBox(height: 8.0),
//                             Text('Number of Shares: ${widget.numberOfShares}'),
//                             SizedBox(height: 8.0),
//                             Text('Price per Share: ${widget.pricePerShare}'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton(
//           onPressed: isRequestingJoin ? null : _sendJoinRequest,
//           child: isRequestingJoin
//               ? CircularProgressIndicator(color: Colors.white)
//               : Text('Send Join Request'),
//           style: ElevatedButton.styleFrom(
//             minimumSize: Size(double.infinity, 50),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProjectDetailsPage extends StatefulWidget {
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

  ProjectDetailsPage({
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

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool isLoading = true;
  bool isRequestingJoin = false;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final storage = FlutterSecureStorage();
  String? username;
  List<dynamic> joinRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchUsername(); // Fetch username when the page initializes
    _fetchJoinRequests(); // Fetch join requests when the page initializes
    _fetchProjectDetails(); // Simulate fetching project details
  }

  Future<void> _fetchUsername() async {
    final user = await storage.read(key: 'username');
    setState(() {
      username = user;
    });
  }

  void _fetchProjectDetails() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _fetchJoinRequests() async {
    final url = Uri.parse('http://13.210.211.177:8000/app/join-table/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        joinRequests = json.decode(response.body); // Parse the response body
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load join requests.')),
      );
    }
  }

  Future<void> _sendJoinRequest() async {
    if (username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to log in to send a join request.')),
      );
      return;
    }

    // Check if the join request already exists
    bool requestExists = joinRequests.any((request) =>
        request['username'] == username &&
        request['projectname'] == widget.proname);

    if (requestExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Join request already sent for this project.')),
      );
      return; // Exit the function if the request exists
    }

    setState(() {
      isRequestingJoin = true;
    });

    final url =
        Uri.parse('http://13.210.211.177:8000/app/create-join-request/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'projectname': widget.proname,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Join request sent successfully!')),
        );
        _fetchJoinRequests(); // Refresh the join requests list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to send join request. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending join request.')),
      );
    } finally {
      setState(() {
        isRequestingJoin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.proname),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.projectlogo.isNotEmpty)
                              Center(
                                child: Image.network(
                                  'http://13.210.211.177:8000${widget.projectlogo}',
                                  width: 170,
                                  height: 200,
                                ),
                              ),
                            SizedBox(height: 16.0),
                            Text(
                              'Name: ${widget.proname}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 8.0),
                            Text('Description: ${widget.description}'),
                            SizedBox(height: 8.0),
                            Text(
                                'Start Date: ${dateFormat.format(widget.startDate)}'),
                            SizedBox(height: 8.0),
                            Text(
                                'Date of Establishment: ${dateFormat.format(widget.dateOfEstablishment)}'),
                            SizedBox(height: 8.0),
                            Text('Location: ${widget.location}'),
                            SizedBox(height: 8.0),
                            Text('Number of Ponds: ${widget.numberOfPonds}'),
                            SizedBox(height: 8.0),
                            Text('Water Capacity: ${widget.waterCapacity}'),
                            SizedBox(height: 8.0),
                            Text(
                                'Annual Production Capacity: ${widget.annualProductionCapacity}'),
                            SizedBox(height: 8.0),
                            Text('Capital: ${widget.capital}'),
                            SizedBox(height: 8.0),
                            Text('Number of Shares: ${widget.numberOfShares}'),
                            SizedBox(height: 8.0),
                            Text('Price per Share: ${widget.pricePerShare}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isRequestingJoin ? null : _sendJoinRequest,
          child: isRequestingJoin
              ? CircularProgressIndicator(color: Colors.white)
              : Text('Send Join Request'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
