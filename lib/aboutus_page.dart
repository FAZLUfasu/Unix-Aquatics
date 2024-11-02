// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AboutUsModel {
//   final String unix;
//   final String vision;
//   final String mission;

//   AboutUsModel({
//     required this.unix,
//     required this.vision,
//     required this.mission,
//   });

//   factory AboutUsModel.fromJson(Map<String, dynamic> json) {
//     return AboutUsModel(
//       unix: json['unix_aquatics'],
//       vision: json['vision'],
//       mission: json['mission'],
//     );
//   }
// }

// class TeamMemberModel {
//   final String name;
//   final String role;
//   final String photoUrl;

//   TeamMemberModel({
//     required this.name,
//     required this.role,
//     required this.photoUrl,
//   });

//   factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
//     return TeamMemberModel(
//       name: json['name'],
//       role: json['role'],
//       photoUrl: json['photo_url'],
//     );
//   }
// }

// class ContactInfoModel {
//   final String email;
//   final String phoneNumber;
//   final String address;

//   ContactInfoModel({
//     required this.email,
//     required this.phoneNumber,
//     required this.address,
//   });

//   factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
//     return ContactInfoModel(
//       email: json['email'],
//       phoneNumber: json['phone_number'],
//       address: json['address'],
//     );
//   }
// }

// Color getColorCode(int index) {
//   List<Color> colors = [
//     Colors.blueAccent,
//     Colors.greenAccent,
//     Colors.orangeAccent,
//     Colors.purpleAccent,
//     Colors.redAccent,
//     Colors.cyanAccent,
//     Colors.pinkAccent,
//     Colors.tealAccent,
//   ];
//   return colors[index % colors.length];
// }

// class ApiService {
//   final String baseUrl;

//   ApiService(this.baseUrl);

//   Future<AboutUsModel> fetchAboutUs() async {
//     final response = await http.get(Uri.parse('$baseUrl/app/AboutUs/'));
//     if (response.statusCode == 200) {
//       return AboutUsModel.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load About Us');
//     }
//   }
//   // Function to return different colors for each card

//   Future<List<TeamMemberModel>> fetchTeamMembers() async {
//     final response = await http.get(Uri.parse('$baseUrl/app/teammember/'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((item) => TeamMemberModel.fromJson(item)).toList();
//     } else {
//       throw Exception('Failed to load Team Members');
//     }
//   }

//   Future<ContactInfoModel> fetchContactInfo() async {
//     final response = await http.get(Uri.parse('$baseUrl/app/contactinfo/'));
//     if (response.statusCode == 200) {
//       return ContactInfoModel.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load Contact Info');
//     }
//   }
// }

// class AboutUsPage extends StatefulWidget {
//   @override
//   _AboutUsPageState createState() => _AboutUsPageState();
// }

// class _AboutUsPageState extends State<AboutUsPage> {
//   final ApiService apiService = ApiService('http://13.210.211.177:8000');

//   late Future<AboutUsModel> aboutUsFuture;
//   late Future<List<TeamMemberModel>> teamMembersFuture;
//   late Future<ContactInfoModel> contactInfoFuture;

//   @override
//   void initState() {
//     super.initState();
//     aboutUsFuture = apiService.fetchAboutUs();
//     teamMembersFuture = apiService.fetchTeamMembers();
//     contactInfoFuture = apiService.fetchContactInfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('About Us'),
//         backgroundColor: Color.fromARGB(255, 120, 189, 247),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             FutureBuilder<AboutUsModel>(
//               future: aboutUsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Failed to load About Us'));
//                 } else if (!snapshot.hasData) {
//                   return Center(child: Text('No data available'));
//                 } else {
//                   final aboutUs = snapshot.data!;
//                   return Column(
//                     children: [
//                       Card(
//                         color: getColorCode(0), // Apply color to the first card
//                         elevation: 4.0,
//                         margin: const EdgeInsets.all(16.0),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Unix Aquatics',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold)),
//                               SizedBox(height: 10),
//                               Text(aboutUs.unix),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color:
//                             getColorCode(1), // Apply color to the second card
//                         elevation: 4.0,
//                         margin: const EdgeInsets.all(16.0),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Vision',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold)),
//                               SizedBox(height: 10),
//                               Text(aboutUs.vision),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: getColorCode(2), // Apply color to the third card
//                         elevation: 4.0,
//                         margin: const EdgeInsets.all(16.0),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Mission',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold)),
//                               SizedBox(height: 10),
//                               Text(aboutUs.mission),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),

//             FutureBuilder<List<TeamMemberModel>>(
//               future: teamMembersFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Failed to load Team Members'));
//                 } else if (!snapshot.hasData) {
//                   return Center(child: Text('No data available'));
//                 } else {
//                   final teamMembers = snapshot.data!;
//                   return ListView.builder(
//                     itemCount: teamMembers.length,
//                     itemBuilder: (context, index) {
//                       final member = teamMembers[index];
//                       return Card(
//                         color:
//                             getColorCode(index), // Apply color based on index
//                         elevation: 4.0,
//                         margin: const EdgeInsets.all(16.0),
//                         child: ListTile(
//                           leading: Image.network(
//                             'http://13.210.211.177:8000${member.photoUrl}',
//                             errorBuilder: (context, error, stackTrace) =>
//                                 Icon(Icons.error),
//                           ),
//                           title: Text(member.name),
//                           subtitle: Text(member.role),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),

//             FutureBuilder<ContactInfoModel>(
//               future: contactInfoFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Failed to load Contact Info'));
//                 } else if (!snapshot.hasData) {
//                   return Center(child: Text('No data available'));
//                 } else {
//                   final contactInfo = snapshot.data!;
//                   return Card(
//                     elevation: 4.0,
//                     margin: const EdgeInsets.all(16.0),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Contact Information',
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold)),
//                           SizedBox(height: 10),
//                           Text('Email: ${contactInfo.email}'),
//                           Text('Phone: ${contactInfo.phoneNumber}'),
//                           Text('Address: ${contactInfo.address}'),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AboutUsModel {
  final String unix;
  final String vision;
  final String mission;

  AboutUsModel({
    required this.unix,
    required this.vision,
    required this.mission,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      unix: json['unix_aquatics'],
      vision: json['vision'],
      mission: json['mission'],
    );
  }
}

class TeamMemberModel {
  final String name;
  final String role;
  final String photoUrl;

  TeamMemberModel({
    required this.name,
    required this.role,
    required this.photoUrl,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      name: json['name'],
      role: json['role'],
      photoUrl: json['photo_url'],
    );
  }
}

class ContactInfoModel {
  final String email;
  final String phoneNumber;
  final String address;

  ContactInfoModel({
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }
}

Color getColorCode1(int index) {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.blueAccent,
    Colors.blueAccent,
    Colors.blueAccent,
    Colors.blueAccent,
    Colors.blueAccent,
    Colors.blueAccent,
  ];
  return colors[index % colors.length];
}

Color getColorCode(int index) {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.cyanAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
  ];
  return colors[index % colors.length];
}

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<AboutUsModel> fetchAboutUs() async {
    final response = await http.get(Uri.parse('$baseUrl/app/AboutUs/'));
    if (response.statusCode == 200) {
      return AboutUsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load About Us');
    }
  }

  Future<List<TeamMemberModel>> fetchTeamMembers() async {
    final response = await http.get(Uri.parse('$baseUrl/app/teammember/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => TeamMemberModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Team Members');
    }
  }

  Future<ContactInfoModel> fetchContactInfo() async {
    final response = await http.get(Uri.parse('$baseUrl/app/contactinfo/'));
    if (response.statusCode == 200) {
      return ContactInfoModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Contact Info');
    }
  }
}

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final ApiService apiService = ApiService('http://13.210.211.177:8000');

  late Future<AboutUsModel> aboutUsFuture;
  late Future<List<TeamMemberModel>> teamMembersFuture;
  late Future<ContactInfoModel> contactInfoFuture;

  @override
  void initState() {
    super.initState();
    aboutUsFuture = apiService.fetchAboutUs();
    teamMembersFuture = apiService.fetchTeamMembers();
    contactInfoFuture = apiService.fetchContactInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        // backgroundColor: Color.fromARGB(255, 120, 189, 247),
      ),
      body: ListView(
        children: [
          FutureBuilder<AboutUsModel>(
            future: aboutUsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Failed to load About Us'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data available'));
              } else {
                final aboutUs = snapshot.data!;
                return Column(
                  children: [
                    Card(
                      color: getColorCode(0),
                      elevation: 4.0,
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Unix Aquatics',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text(aboutUs.unix),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: getColorCode(1),
                      elevation: 4.0,
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vision',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text(aboutUs.vision),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: getColorCode(2),
                      elevation: 4.0,
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mission',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text(aboutUs.mission),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          FutureBuilder<List<TeamMemberModel>>(
            future: teamMembersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load Team Members'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data available'));
              } else {
                final teamMembers = snapshot.data!;
                return Column(
                  children: teamMembers.map((member) {
                    return Card(
                      color: getColorCode1(teamMembers.indexOf(member)),
                      elevation: 4.0,
                      margin: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.network(
                            'http://13.210.211.177:8000${member.photoUrl}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                        ),
                        title: Text(member.name),
                        subtitle: Text(member.role),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
          FutureBuilder<ContactInfoModel>(
            future: contactInfoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load Contact Info'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data available'));
              } else {
                final contactInfo = snapshot.data!;
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contact Information',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Email: ${contactInfo.email}'),
                        Text('Phone: ${contactInfo.phoneNumber}'),
                        Text('Address: ${contactInfo.address}'),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
