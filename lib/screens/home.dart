import 'package:flutter/material.dart';
import 'package:flutter_project/route/route.dart' as route;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> items = ["One", "Two", "Three"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlutterLogo(size: 57),
              Text(
                "RDP Guestbook",
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
              SizedBox(width: 12),
              Icon(Icons.notifications),
              IconButton(
                icon: Icon(Icons.info),
                onPressed: null,
              ),
            ]),
      ),
      drawer: Drawer(),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.email),
              label: 'Contact Us',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'About Us',
            ),
          ],
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, route.homePage);
                break;
              case 1:
                Navigator.pushNamed(context, route.contactUs);
                break;
              case 2:
                Navigator.pushNamed(context, route.aboutUs);
                break;
            }
          }),
    );
  }
}
