// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Profile> fetchProfile() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      final username = await _storage.read(key: 'username');

      if (token == null || username == null) {
        throw Exception('No token or username found');
      }

      final apiUrl =
          'http://13.210.211.177:8000/app/investorprofile/username/$username/';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Token $token',
        },
      ).timeout(Duration(seconds: 30)); // Increase the timeout to 30 seconds

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Profile.fromJson(data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }
}

class Profile {
  final String email;
  final String? profilePic;
  final String profilePicName;
  final String name;
  final String address;
  final String mobileNumber;
  final String? whatsapp;
  final String? aadharCard;
  final String? aadharCardAttachment;
  final String? electionId;
  final String? electionIdAttachment;
  final String? passportNumber;
  final String? passportAttachment;
  final String? panCardNumber;
  final String? panCardAttachment;
  final String? accountNumber;
  final String? iban;
  final String? bankName;
  final String? branch;
  final String? ifscCode;
  final String? bankAccountPassbookAttachment;
  final int user;

  Profile({
    required this.email,
    this.profilePic,
    required this.profilePicName,
    required this.name,
    required this.address,
    required this.mobileNumber,
    this.whatsapp,
    this.aadharCard,
    this.aadharCardAttachment,
    this.electionId,
    this.electionIdAttachment,
    this.passportNumber,
    this.passportAttachment,
    this.panCardNumber,
    this.panCardAttachment,
    this.accountNumber,
    this.iban,
    this.bankName,
    this.branch,
    this.ifscCode,
    this.bankAccountPassbookAttachment,
    required this.user,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'http://13.210.211.177:8000/media/';
    return Profile(
      email: json['email'] ?? '',
      profilePic: '$baseUrl${json['profilepic']}',
      profilePicName: json['profilepicname'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      whatsapp: json['whatsapp'],
      aadharCard: json['aadhar_card'],
      aadharCardAttachment: json['aadhar_card_attachment'],
      electionId: json['election_id'],
      electionIdAttachment: json['election_id_attachment'],
      passportNumber: json['passport_number'],
      passportAttachment: json['passport_attachment'],
      panCardNumber: json['pan_card_number'],
      panCardAttachment: json['pan_card_attachment'],
      accountNumber: json['account_number'],
      iban: json['iban'],
      bankName: json['bank_name'],
      branch: json['branch'],
      ifscCode: json['ifsc_code'],
      bankAccountPassbookAttachment: json['bank_account_passbook_attachment'],
      user: json['user'] ?? 0,
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Profile> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = ProfileService().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<Profile>(
        future: futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No profile found'));
          } else {
            final profile = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: profile.profilePic != null
                                ? NetworkImage(profile.profilePic!)
                                : AssetImage('assets/default-profile.png')
                                    as ImageProvider,
                            radius: 40,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                Text('Email: ${profile.email}'),
                                Text('Mobile: ${profile.mobileNumber}'),
                                Text(
                                    'Address: ${profile.address.replaceAll('\r\n', ', ')}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      if (profile.whatsapp != null)
                        Text('WhatsApp: ${profile.whatsapp!}'),
                      if (profile.aadharCard != null)
                        Text('Aadhar Card: ${profile.aadharCard!}'),
                      if (profile.passportNumber != null)
                        Text('Passport Number: ${profile.passportNumber!}'),
                      if (profile.panCardNumber != null)
                        Text('PAN Card Number: ${profile.panCardNumber!}'),
                      if (profile.bankName != null)
                        Text('Bank Name: ${profile.bankName!}'),
                      if (profile.iban != null) Text('IBAN: ${profile.iban!}'),
                      if (profile.branch != null)
                        Text('Branch: ${profile.branch!}'),
                      if (profile.ifscCode != null)
                        Text('IFSC Code: ${profile.ifscCode!}'),
                      if (profile.accountNumber != null)
                        Text('Account Number: ${profile.accountNumber!}'),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
