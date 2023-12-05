import 'package:carousel_slider/carousel_slider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter_project/route/route.dart' as route;
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: [
            CarouselSlider(
                options: CarouselOptions(
                  height: 230.0,
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
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/business.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/engineer.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/nursing.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/software.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ]),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('guests')
                    .orderBy('created', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Oops, something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: Colors.red,
                    );
                  }

                  return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        final firestoreTimestamp = data['created'] as Timestamp;
                        final dateTime = firestoreTimestamp.toDate();
                        final timeAgo =
                            timeago.format(dateTime, locale: 'en_short');

                        return ListTile(
                          leading: Text('↪' + ' ' + data['guest_name']),
                          title: Text(data['message']),
                          trailing: Text(
                            timeAgo,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList());
                })
          ],
        ),
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.lightBlue,
                  title: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Leave a Message'),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      TextFormField(),
                    ]),
                  ),
                );
              });
        },
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
