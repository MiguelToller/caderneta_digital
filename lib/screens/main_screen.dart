import 'package:flutter/material.dart';
import '../database/database.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'record_form_screen.dart';
import 'profile_screen.dart';
import 'calendar_screen.dart';

class MainScreen extends StatefulWidget {
  final Usuario user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(user: widget.user),
      HistoryScreen(user: widget.user),
      CalendarScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Carteira'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: 'Calendário'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      floatingActionButton: (_currentIndex == 0 || _currentIndex == 1) ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => RecordFormScreen(user: widget.user)),
          );
        },
        label: const Text('Novo Registro'),
        icon: const Icon(Icons.add),
      ) : null,
    );
  }
}
