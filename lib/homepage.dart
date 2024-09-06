import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String result = "";
  String lat = "";
  String lng = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text("USER CURRENT LOCATION",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(40),
                    // border: Border.all(color: Colors.red)
                  ),
                  child: Image.asset('assets/googlemapps.png'),
                ),
              ),
            ),
            SizedBox(height: 40,),
            _getMapButton(),
            SizedBox(height: 40,),
            _getLocationButton(),
            displayLocation()
          ],
        ),
      ),
    );
  }

  Widget _getMapButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(300, 50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          gotoMap();
        },
        child: Text("Goto Google Map", style: TextStyle(
            fontSize: 20,
          fontWeight: FontWeight.bold,color: Colors.white
        ),)

    );
  }


  Widget _getLocationButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(300, 50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          getUserLocation();
        },
        child: Text("Get Location", style: TextStyle(
            fontSize: 20,
          fontWeight: FontWeight.bold,color: Colors.white

        ),)
    );
  }


  //check if location permission is enable
  Future<bool> checkPermission() async {
    bool isEnable = false;
    LocationPermission permission;

    //check if location is enable
    isEnable = await Geolocator.isLocationServiceEnabled();
    if (!isEnable) {
      return false;
    }

    //check if use allow location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // if permission is denied then request user to allow permission again
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // if permission denied again
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }


  //get user current location
  getUserLocation() async {
    var isEnable = await checkPermission();
    if (isEnable) {
      Position location = await Geolocator.getCurrentPosition();
      setState(() {
        result = "";
        lat = location.latitude.toString();
        lng = location.latitude.toString();
      });
    } else {
      setState(() {
        result = "Permissoin is not allow";
      });
    }
  }

  Widget displayLocation() {
    return Column(
      children: [
        Text(result, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        Text(lat, style: TextStyle(fontSize: 30,),),
        Text(lng,  style: TextStyle(fontSize: 30),),
      ],
    );
  }

  gotoMap() {
    try {
      var url ="https://www.google.com/maps/dir/?api=1&destination=";
          //"https://www.google.com/maps/dir/?api=1&destination=11.6021526,104.9112173";
      final Uri _url = Uri.parse(url);
      launchUrl(_url);
    } catch (_) {
      print("Error launch Map");
    }
  }
}