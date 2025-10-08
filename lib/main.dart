import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart'; 
import 'dart:async';
import 'detail_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Link Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppLinks _appLinks;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleIncomingLinks();
  }

  void _handleIncomingLinks() {
    _sub = _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        _navigateFromLink(uri);
      }
    }, onError: (err) {
      print('Error parsing incoming link: $err');
    });
  }

  void _navigateFromLink(Uri uri) {
    if (uri.host == 'details' && uri.pathSegments.isNotEmpty) {
      final id = uri.pathSegments[0];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailsScreen(id: id)),
      );
    } else if (uri.host == 'profile' && uri.pathSegments.isNotEmpty) {
      final username = uri.pathSegments[0];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(username: username)),
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetailsScreen(id: '1')),
                );
              },
              child: const Text('Open Details'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen(username: 'alex')),
                );
              },
              child: const Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
