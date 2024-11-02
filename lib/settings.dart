// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:unix/themprovider.dart';
// // Import the ThemeProvider

// class SettingsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: Center(
//         child: SwitchListTile(
//           title: Text('Dark Mode'),
//           value: themeProvider.isDarkMode,
//           onChanged: (value) {
//             themeProvider.toggleTheme();
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unix/themprovider.dart'; // Import the ThemeProvider

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for better spacing
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the start
          children: [
            SizedBox(height: 16.0), // Add space between title and switch
            SwitchListTile(
              title: Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
            // You can add more SwitchListTile widgets for other settings
          ],
        ),
      ),
    );
  }
}
