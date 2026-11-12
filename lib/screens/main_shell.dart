import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'quiz_screens.dart';
import 'revision_screen.dart';
import 'roadmap_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _i = 0;
  static const _pages = [
    HomeScreen(), RoadmapScreen(), RevisionScreen(), QuizListScreen(), ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _i, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _i,
          onDestinationSelected: (v) => setState(() => _i = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.map_rounded), label: 'Roadmap'),
            NavigationDestination(icon: Icon(Icons.replay_rounded), label: 'Revision'),
            NavigationDestination(icon: Icon(Icons.quiz_rounded), label: 'Quizzes'),
            NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      );
}
