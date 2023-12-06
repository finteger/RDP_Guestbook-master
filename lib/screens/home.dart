import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
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
  //Ceate a Firestore instance
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> items = ["One", "Two", "Three"];

  //Controller to capture user input for message
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  //Add a new guest post to the 'guests' collection
  Future<void> addGuestPost() async {
    db
        .collection('guests')
        .add({
          'guest_name': myController1.text,
          'message': myController2.text,
          'created': DateTime.now(),
        })
        .then((value) => print("Guest & message added"))
        .catchError((error) => print("Failed to add guest & message: $error"));
  }

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
          color: Colors.black,
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
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('guests')
                      .orderBy('created', descending: true)
                      .snapshots(),
                  //These are real-time snapshots of collections
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    // Async snapshot data from the stream

                    //Error handling if the db has an issue
                    if (snapshot.hasError) {
                      return const Text('Oops, something went wrong');
                    }

                    /*If the connectionState is equal to an enum (named lists), we are
                      returning the progress indicator.  */

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: Colors.red,
                      );
                    }

                    //Returning UI
                    return Scrollbar(
                      thumbVisibility: true,
                      thickness: 8,
                      radius: Radius.circular(23),
                      child: SizedBox(
                        height: 474,
                        child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            /*Dynamically displaying snapshot data (streaming documents) 
                             and we call the data method with null assertion operator */
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              /*Data is turned as a Map with key-value pair in mind.  Key is always String, and
                          the value will always be dynamic, denoting any sort of data type */
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;

                              final firestoreTimestamp =
                                  data['created'] as Timestamp;
                              final dateTime = firestoreTimestamp.toDate();
                              final timeAgo =
                                  timeago.format(dateTime, locale: 'en_short');

                              return ListTile(
                                leading: Text(
                                  '➢' + ' ' + data['guest_name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      data['message'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        background: Paint()
                                          ..color = Colors.blue
                                          ..strokeWidth = 30
                                          ..style = PaintingStyle.stroke
                                          ..strokeJoin = StrokeJoin.round
                                          ..strokeCap = StrokeCap.round,
                                      ),
                                    ),
                                    Icon(Icons.format_quote,
                                        color: Colors.yellow),
                                  ],
                                ),
                                trailing: Text(
                                  timeAgo,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList()),
                      ),
                    );
                  }),
            )
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
                  content: Form(
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                        TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(9)
                          ],
                          controller: myController1,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            icon: Icon(Icons.account_box),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(18)
                          ],
                          maxLines: 8,
                          controller: myController2,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            icon: Icon(Icons.message),
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        addGuestPost();
                        Navigator.pop(context);
                      },
                      child: Text('Submit'),
                    )
                  ],
                );
              });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.email, color: Colors.white),
              label: 'Contact Us',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.white),
              label: 'About Us',
            ),
          ],
          //zero-based index.  buttons match the case and return a named route when pressed.
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
