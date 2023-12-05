import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/route/route.dart' as route;
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

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
              Text(
                "Guestbook",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w500),
              ),
              IconButton(
                icon: Icon(Icons.info),
                onPressed: null,
              ),
              SignOutButton(),
            ]),
      ),
      body: Column(
        children: [
          CarouselSlider(
              options: CarouselOptions(
                height: 280.0,
                autoPlay: true,
                autoPlayInterval: Duration(milliseconds: 2200),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
              ),
              items: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/download.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/business.jpg'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/engineer.jpg'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/nursing.jpg'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/software.jpg'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ]),
        ],
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
