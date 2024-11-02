// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:unix/HomePage.dart';
import 'package:unix/aboutus_page.dart';
import 'package:unix/profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class MyProjectModel {
  final int id;
  final String username;
  final String email;
  final String project;
  final String projectlogo;
  final String projectlogoname;
  final String description;
  final String startDate;
  final String endDate;
  final String dateOfEstablishment;
  final String location;
  final int numberOfPonds;
  final double waterCapacity;
  final double annualProductionCapacity;
  final String capital;
  final int numberOfShares;
  final String pricePerShare;
  final String investmentAmount;
  final String investmentDate;
  final String receipt; // Non-nullable
  final int installments;
  final String totalInvestment;
  final int totalNumberOfShares;
  final String investmentPricePerShare;
  final int sharesHolding;
  final String shareCertificate; // Non-nullable
  final String dividendDate;
  final String dividendAmount;
  final String transferProof; // Non-nullable
  final String totalDividend;
  final String partnershipAgreement; // Non-nullable
  final String otherAgreements; // Non-nullable
  final int proname;
  final int user;

  MyProjectModel({
    required this.id,
    required this.username,
    required this.email,
    required this.project,
    required this.projectlogo,
    required this.projectlogoname,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.dateOfEstablishment,
    required this.location,
    required this.numberOfPonds,
    required this.waterCapacity,
    required this.annualProductionCapacity,
    required this.capital,
    required this.numberOfShares,
    required this.pricePerShare,
    required this.investmentAmount,
    required this.investmentDate,
    required this.receipt, // Non-nullable
    required this.installments,
    required this.totalInvestment,
    required this.totalNumberOfShares,
    required this.investmentPricePerShare,
    required this.sharesHolding,
    required this.shareCertificate, // Non-nullable
    required this.dividendDate,
    required this.dividendAmount,
    required this.transferProof, // Non-nullable
    required this.totalDividend,
    required this.partnershipAgreement, // Non-nullable
    required this.otherAgreements, // Non-nullable
    required this.proname,
    required this.user,
  });

  factory MyProjectModel.fromJson(Map<String, dynamic> json) {
    return MyProjectModel(
      id: json['id'],
      username: json['username'],
      email: json['email'] ?? '',
      project: json['project'],
      projectlogo: json['projectlogo'],
      projectlogoname: json['projectlogoname'],
      description: json['description'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      dateOfEstablishment: json['date_of_establishment'],
      location: json['location'],
      numberOfPonds: json['number_of_ponds'],
      waterCapacity: (json['water_capacity'] as num).toDouble(),
      annualProductionCapacity:
          (json['annual_production_capacity'] as num).toDouble(),
      capital: json['capital'],
      numberOfShares: json['number_of_shares'],
      pricePerShare: json['price_per_share'],
      investmentAmount: json['investment_amount'],
      investmentDate: json['investment_date'],
      receipt: json['receipt'] ?? '', // Defaulting to empty string
      installments: json['installments'],
      totalInvestment: json['total_investment'],
      totalNumberOfShares: json['total_number_of_shares'],
      investmentPricePerShare: json['investment_price_per_share'],
      sharesHolding: json['shares_holding'],
      shareCertificate:
          json['share_certificate'] ?? '', // Defaulting to empty string
      dividendDate: json['dividend_date'],
      dividendAmount: json['dividend_amount'],
      transferProof: json['transfer_proof'] ?? '', // Defaulting to empty string
      totalDividend: json['total_dividend'],
      partnershipAgreement:
          json['partnership_agreement'] ?? '', // Defaulting to empty string
      otherAgreements:
          json['other_agreements'] ?? '', // Defaulting to empty string
      proname: json['proname'],
      user: json['user'],
    );
  }
}

class MyProjectPage extends StatefulWidget {
  @override
  _MyProjectPageState createState() => _MyProjectPageState();
}

class _MyProjectPageState extends State<MyProjectPage> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  MyProjectModel? projectModel; // Initialize the projectModel variable
  int _selectedIndex = 1; // Start with the Projects tab selected

  static final List<Widget> _pages = <Widget>[
    HomePage(),
    // Avoid including MyProjectPage to prevent recursion
    Placeholder(), // Use a placeholder or another page
    ProfilePage(),
    AboutUsPage(),
  ];

  @override
  void initState() {
    super.initState();
    fetchProjectData();
  }

  Future<void> fetchProjectData() async {
    try {
      final username = await _storage.read(key: 'username');

      if (username == null) {
        throw Exception('No username found');
      }

      final response = await http.get(
        Uri.parse(
            'http://13.210.211.177:8000/app/myprojects/username/$username/'),
      );

      if (response.statusCode == 200) {
        setState(() {
          projectModel = MyProjectModel.fromJson(json.decode(response.body)[0]);
        });
      } else {
        throw Exception('Failed to load project data');
      }
    } catch (e) {
      // Log the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load project data')),
      );
    }
  }

  // ignore: unused_element
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[_selectedIndex]),
    );
  }

  // Future<void> _downloadFile(
  //     String url, String filename, BuildContext context) async {
  //   try {
  //     // Get the directory for storing files based on the platform
  //     Directory? directory;
  //     if (Platform.isAndroid) {
  //       // For Android, use the Downloads directory
  //       final externalDir = await getExternalStorageDirectory();
  //       directory = Directory('${externalDir?.path}/Download');
  //     } else if (Platform.isIOS) {
  //       // For iOS, use the Documents directory
  //       directory = await getApplicationDocumentsDirectory();
  //     } else {
  //       // Fallback for other platforms
  //       directory = await getApplicationDocumentsDirectory();
  //     }

  //     // Create the directory if it does not exist
  //     if (!await directory.exists()) {
  //       await directory.create(recursive: true);
  //     }

  //     final filePath = '${directory.path}/$filename';

  //     // Download the file
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('$filename downloaded to $filePath')),
  //       );
  //     } else {
  //       throw Exception('Failed to download file');
  //     }
  //   } catch (e) {

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to download $filename')),
  //     );
  //   }
  // }
  Future<void> _downloadFile(
      String url, String filename, BuildContext context) async {
    try {
      // Get the directory for storing files based on the platform
      Directory? directory;
      if (Platform.isAndroid) {
        // For Android, use the Downloads directory
        final externalDir = await getExternalStorageDirectory();
        directory = Directory('${externalDir?.path}/Download');
      } else if (Platform.isIOS) {
        // For iOS, use the Documents directory
        directory = await getApplicationDocumentsDirectory();
      } else {
        // Fallback for other platforms
        directory = await getApplicationDocumentsDirectory();
      }

      // Create the directory if it does not exist
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$filename';

      // Download the file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get the Content-Type from the response
        final contentType = response.headers['content-type'];
        final fileExtension = _getFileExtension(contentType);

        // Append the correct file extension if necessary
        final filePathWithExtension =
            fileExtension != null ? filePath + fileExtension : filePath;

        final file = File(filePathWithExtension);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('$filename downloaded to $filePathWithExtension')),
        );
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
  
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download $filename')),
      );
    }
  }

// Helper function to determine file extension from Content-Type
  String? _getFileExtension(String? contentType) {
    if (contentType == null) return null;

    switch (contentType) {
      case 'application/pdf':
        return '.pdf';
      case 'image/jpeg':
        return '.jpg';
      case 'image/png':
        return '.png';
      case 'application/zip':
        return '.zip';
      // Add more MIME types as needed
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Project'),
        // backgroundColor: Color.fromARGB(255, 120, 189, 247),
      ),
      body: projectModel == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  if (projectModel?.projectlogo != null)
                    Image.network(
                        'http://13.210.211.177:8000/app${projectModel?.projectlogo}'),
                  SizedBox(height: 16),
                  _buildInfoCard('Project Info', [
                    'Project: ${projectModel?.project}',
                    'Username: ${projectModel?.username}',
                    'Email: ${projectModel?.email}',
                    'Location: ${projectModel?.location}',
                    'Start Date: ${projectModel?.startDate}',
                    'End Date: ${projectModel?.endDate}',
                    'Date of Establishment: ${projectModel?.dateOfEstablishment}',
                  ]),
                  SizedBox(height: 16),
                  _buildInfoCard('Investment Details', [
                    'Capital: ${projectModel?.capital}',
                    'Number of Shares: ${projectModel?.numberOfShares}',
                    'Price per Share: ${projectModel?.pricePerShare}',
                    'Investment Amount: ${projectModel?.investmentAmount}',
                    'Investment Date: ${projectModel?.investmentDate}',
                    // if (projectModel?.receipt != null)
                    //   'Receipt: ${projectModel?.receipt}',
                    'Installments: ${projectModel?.installments}',
                    'Total Investment: ${projectModel?.totalInvestment}',
                    'Total Number of Shares: ${projectModel?.totalNumberOfShares}',
                    'Investment Price per Share: ${projectModel?.investmentPricePerShare}',
                    'Shares Holding: ${projectModel?.sharesHolding}',
                    // if (projectModel?.shareCertificate != null)
                    //   'Share Certificate: ${projectModel?.shareCertificate}',
                    'Dividend Date: ${projectModel?.dividendDate}',
                    'Dividend Amount: ${projectModel?.dividendAmount}',
                    // if (projectModel?.transferProof != null)
                    //   'Transfer Proof: ${projectModel?.transferProof}',
                    'Total Dividend: ${projectModel?.totalDividend}',
                  ]),
                  SizedBox(height: 16),
                  _buildFileCard('Partnership Agreement',
                      projectModel?.partnershipAgreement ?? ''),
                  _buildFileCard(
                      'Other Agreements', projectModel?.otherAgreements ?? ''),
                  _buildFileCard(
                      'Receipt',
                      projectModel?.receipt ??
                          ''), // Download button for receipt
                  _buildFileCard(
                      'Share Certificate',
                      projectModel?.shareCertificate ??
                          ''), // Download button for share certificate
                  _buildFileCard(
                      'Transfer Proof',
                      projectModel?.transferProof ??
                          ''), // Download button for transfer proof
                ],
              ),
            ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.work),
      //       label: 'Projects',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.info),
      //       label: 'About Us',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.blue,
      //   onTap: _onItemTapped,
      // ),
    );
  }

  Widget _buildInfoCard(String title, List<String> details) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            for (var detail in details)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(detail),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileCard(String title, String fileUrl) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.download),
              onPressed: fileUrl.isNotEmpty
                  ? () => _downloadFile(
                      'http://13.210.211.177:8000/app$fileUrl',
                      title,
                      context) // Ensure context is passed here
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFileCard(String title, String fileUrl) {
  //   return Card(
  //     elevation: 4,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.download),
  //             onPressed: fileUrl.isNotEmpty
  //                 ? () => _downloadFile(
  //                     'http://13.210.211.177:8000/app$fileUrl', title)
  //                 : null,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
}
