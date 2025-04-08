import 'package:flutter/material.dart';
import 'package:new_ui/screen/ai_therapist_screen.dart';
import 'package:new_ui/screen/analytics_screen.dart';
import 'package:new_ui/screen/home_screen.dart';
import 'package:new_ui/screen/resources_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SimpleBottomNav(),
    );
  }
}

class SimpleBottomNav extends StatefulWidget {
  const SimpleBottomNav({super.key});

  @override
  _SimpleBottomNavState createState() => _SimpleBottomNavState();
}

class _SimpleBottomNavState extends State<SimpleBottomNav> {
  int _selectedIndex = 1; // default selected index

  final List<IconData> _icons = [
    Icons.sentiment_satisfied,
    Icons.favorite_border,
    Icons.chat_bubble_sharp,
    Icons.backpack,
    Icons.flag,
  ];

  final List<Widget> _pages = [
    HomeScreen(),
    AnalyticsScreen(),
    AiTherapistScreen(),
    ResourcesScreen(),
    Center(child: Text('Setting Page', style: TextStyle(fontSize: 24))),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavIcon(int index) {
    bool isSelected = index == _selectedIndex;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              )
            : null,
        padding: EdgeInsets.all(10),
        child: Icon(
          _icons[index],
          color: isSelected ? Colors.white : Colors.brown,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _icons.length,
              (index) => _buildNavIcon(index),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFFFDF6EC),
    );
  }
}
