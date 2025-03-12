import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luminious',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  bool _bulbState = false;
  bool _plugState = false;

  @override
  void initState() {
    super.initState();
    _dbRef.child('bulb').onValue.listen((event) {
      setState(() {
        _bulbState = event.snapshot.value == true;
      });
    });
    _dbRef.child('plug').onValue.listen((event) {
      setState(() {
        _plugState = event.snapshot.value == true;
      });
    });
  }

  void _toggleBulb() {
    bool newState = !_bulbState;
    _dbRef.child('bulb').set(newState);
  }

  void _togglePlug() {
    bool newState = !_plugState;
    _dbRef.child('plug').set(newState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Luminious'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        elevation: 5,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildControlButton(
              title: "Bulb",
              isActive: _bulbState,
              onPressed: _toggleBulb,
              icon: Icons.lightbulb,
            ),
            SizedBox(height: 20),
            _buildControlButton(
              title: "Plug",
              isActive: _plugState,
              onPressed: _togglePlug,
              icon: Icons.power,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String title,
    required bool isActive,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 250,
        height: 80,
        decoration: BoxDecoration(
          color: isActive ? Colors.greenAccent[700] : Colors.grey[850],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.greenAccent : Colors.grey[700]!,
              blurRadius: isActive ? 15 : 5,
              spreadRadius: isActive ? 3 : 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.black : Colors.white,
              size: 35,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
