// This file contains the Main Screen for the app
import 'dart:async';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/services.dart';
import 'package:mailto/mailto.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:waze_link_generator/conv_link.dart';

sendEmail() async {
  final defaultEmailCliLink = Mailto(
    to: ["sri.skumar05@gmail.com"],
    subject: 'Maps4You Support'
  );
  await launchUrlString(defaultEmailCliLink.toString());
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

    String geocode = '';

    gmapsRegexMatch(String sharedURL) async{
    RegExp gmapsRegex = RegExp(r'(http(s?)://)?((maps\.google\.[a-z]+/)|((www\.)?google\.[a-z]+/maps/)|(maps.app.goo.gl)).*');
    if( gmapsRegex.hasMatch(sharedURL)) {
      geocode = await getGeometry(gmapsRegex.stringMatch(sharedURL).toString());
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

  // Get shared data when app is in memory
  StreamSubscription intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) async {
  if (value != null) {
    gmapsRegexMatch(value);
    }
  });

  // Get shared data when app is not in memory
  ReceiveSharingIntent.getInitialText().then((String? value) {
    if(value != null) {
      gmapsRegexMatch(value);
    }
    });
  }

  // Pop Up Box for when the location is only APPROXIMATE
  void _showApproximateLocationPopUpBox(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('The Processed Location is only Approximate'),
        content: const Text('Do You still Wish to Proceed?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              _showPopUpBox(context, LatLng); // Use LatLng here because geocode will contain the string
              // "APPROXIMATE"
            },
            child: const Text('Proceed')
          )
        ]
      )
    );
  }

  // Pop Up Box to Open in Waze or Apple Maps
  void _showPopUpBox(BuildContext context, String geocode) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Your Link has been Processed'),
        content: const Text('Where would you like to open it?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () async{
              Navigator.pop(context);
              await LaunchApp.openApp(iosUrlScheme: "https://www.waze.com/ul?ll=$geocode&navigate=yes", openStore: false);
            },
            child: const Text('Waze'),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              Navigator.pop(context);
              await LaunchApp.openApp(iosUrlScheme: "http://maps.apple.com/?ll=$geocode&z=20", openStore: false);
            },
            child: const Text('Apple Maps')
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    if(geocode != '') {
      if (geocode == "APPROXIMATE") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showApproximateLocationPopUpBox(context);
          geocode = '';
        });
      }
      else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showPopUpBox(context, geocode);
          geocode = '';
        });
      }
    }
      
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 7, 7),
      resizeToAvoidBottomInset: true,
      
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 40), 
          ),

          // Maps4You Title Text
          SizedBox(
            height: 45,
            width: 200,
            child: Align (
              alignment: Alignment(0, 0),
              child: Text("Maps4You", 
              style: TextStyle(
              fontFamily: 'SFProDisplay-Regular',
              fontSize: 30,
              color: const Color(0xffffffff),
              letterSpacing: 1.5,
              ),
            ),
            )
          ),   
          
          // Divider
          const Divider(
            color: Colors.grey,
            thickness: 1),
          
          // How to Use Heading Text
          SizedBox(
            height: 35,
            width: 190,
            child: Align (
              alignment: Alignment(0, 0),
              child: Text("How to Use",
              style: TextStyle(
                fontFamily: 'SFProDisplay-Regular',
                fontSize: 25,
                color: const Color(0xffffffff),
                letterSpacing: 1.5,
                )
              )
            )
          ),
          
          // Container for How to Use Bulleted Text
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(88, 109, 109, 109),
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BulletedList(
                bullet: Icon(
                  Icons.arrow_right_alt_sharp,
                  color: Colors.blue,
                ),
                style: TextStyle(
                  fontFamily: 'SFProDisplay-Regular',
                  fontSize: 15,
                  color: const Color(0xffffffff),
                  letterSpacing: 1.5,
                ),
                listItems: [
                  'Share any Google Maps Link to The App Directly by: Share > Maps4You',
                  'Once the Link is Done Processing, Choose Where You Want to Open it',
                  'Or, Use the TextBox Below to Manually Enter Google Maps Link',
                  'Click (Lat,Lng) Button to Copy Geocode'
                  ]  
                )
              ]
            ),
          ),
          
          SizedBox(height:15),
          
          SizedBox(
            height: 35,
            width: 250,
            child: Align (
              alignment: Alignment(-0.15, -3.5),
              child: Text("Manual Activity",
              style: TextStyle(
                fontFamily: 'SFProDisplay-Regular',
                fontSize: 25,
                color: const Color(0xffffffff),
                letterSpacing: 1.5,
                )
              )
            )
          ),

          // Contains Textfield to Manually enter gmaps url and Lat,Lng copy button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              
              // TextField to Manually Enter Gmaps URL
              SizedBox(
              width: 225.0,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor:  Color.fromARGB(88, 189, 189, 189),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100)),
                  hintText: "Enter Google Maps Link",
                  hintStyle: TextStyle(
                    fontFamily: 'SFProDisplay-Regular',
                    fontSize: 15,
                    color: Color.fromARGB(170, 255, 255, 255),
                    letterSpacing: 1.5,
                    )
                  ),
                  style: TextStyle(
                    fontFamily: 'SFProDisplay-Regular',
                    fontSize: 15,
                    color: Color.fromARGB(255, 255, 255, 255),
                    letterSpacing: 1.5,
                  ),
                onSubmitted: (value) => gmapsRegexMatch(value),
              ),
            ),

            // Button to Copy Lat,Lng
            FloatingActionButton.extended(
                onPressed: () {
                if(LatLng!='') 
                  Clipboard.setData(ClipboardData(text: '$LatLng'));
                  const snackBar = SnackBar(
                  content: Text('Copied to Clipboard',
                    style: TextStyle(fontFamily: 'SFProDisplay-Regular',
                      fontSize: 16,
                      color: Color(0xffffffff),
                      letterSpacing: 1.6,
                    ),
                  textAlign: TextAlign.center,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              label: const Text('Lat,Lng'),
              backgroundColor: Color.fromARGB(255, 3, 169, 244),
              icon: const Icon(Icons.add_location_rounded),
              ),
            ],
          ),

          SizedBox(height:15),
          
          SizedBox(
            height: 35,
            width: 190,
            child: Align (
              alignment: Alignment(0, 0),
              child: Text("Contact Me",
              style: TextStyle(
                fontFamily: 'SFProDisplay-Regular',
                fontSize: 25,
                color: const Color(0xffffffff),
                letterSpacing: 1.5,
                )
              )
            )
          ),

          SizedBox(height:15),

          Align(
            alignment: Alignment(0,0),
            child: SizedBox(
              width: 360,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue, width: 2),
                ),
              onPressed: () {sendEmail();}, 
              child: Text("Send an Email",
                style: TextStyle(
                  fontFamily: 'SFProDisplay-Regular',
                  fontSize: 15,
                  color: const Color(0xffffffff),
                  letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.start,
                )
              )
            ),
          )
        ],
      ), 
      )
    );
  }
}