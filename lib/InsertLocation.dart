import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:moj_majstor/InternetConnection.dart';
import 'package:overlay_support/overlay_support.dart';

class InsertLocation extends StatefulWidget {
  final StringCallback callback;
  const InsertLocation({Key? key, required this.callback}) : super(key: key);

  @override
  State<InsertLocation> createState() => _InsertLocationState();
}

typedef StringCallback = void Function(String val);

class _InsertLocationState extends State<InsertLocation> {
  late GoogleMapController mapController;
  late LatLng _center = const LatLng(43.8685079, 20.6568881);
  //late Set<Marker> _markers;
  late final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  late CameraPosition currentCameraPosition = CameraPosition(target: _center);
  String locationName = "Loading..";
  bool isMove = false;
  String googleApikey = "AIzaSyDY-N_L-dOwIQ_b-VQ0FkqFhQkZoQx-XQQ";
  String locationSearch = "Search Location";

  // = Marker(markerId: MarkerId('myposition'),position: _center);

  @override
  initState() {
    super.initState();
    _determinePosition().then((Position p) => setState(() {
          _center = LatLng(p.latitude, p.longitude);
          moveCamera(_center);
          _markers[const MarkerId('myposition')] =
              Marker(markerId: const MarkerId('myposition'), position: _center);
        }));
  }

  void moveCamera(LatLng latlang) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latlang, zoom: 17.0)));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 7.58,
              ),
              markers: Set<Marker>.of(_markers.values),
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onTap: (LatLng latlang) {
                moveCamera(latlang);
              },
              onCameraMove: (CameraPosition cameraPositiona) {
                isMove = true;

                setState(() => {});
                currentCameraPosition = cameraPositiona; //when map is dragging
              },
              onCameraIdle: () async {
                isMove = false;
                //when map drag stops
                if (InternetConnection.isDeviceConnected) {
                  placemarkFromCoordinates(
                          currentCameraPosition.target.latitude,
                          currentCameraPosition.target.longitude)
                      .then((List<Placemark> placemarks) {
                    setState(() {
                      //get place name from lat and lang
                      locationName = placemarks.first.locality.toString() +
                          ", " +
                          placemarks.first.street.toString();
                    });
                  });
                } else {
                  locationName = 'Loading..';
                }
              },
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Center(
              //picker image on google map
              child: AnimatedPadding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, isMove ? 110 : 80),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutCubic,
                child: Container(
                  child: Image.asset(
                    isMove
                        ? "assets/img/mappicker1.png"
                        : "assets/img/mappicker2.png",
                    width: 80,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              width: 1,
              height: 1,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutCubic,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: isMove ? 7 : 3,
                    blurRadius: isMove ? 7 : 3,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              //widget to display location name
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Card(
                      child: Container(
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            leading: Image.asset(
                              "assets/img/mappicker1.png",
                              width: 25,
                            ),
                            title: Text(
                              locationName,
                              style: const TextStyle(fontSize: 18),
                            ),
                            dense: true,
                          )),
                    ),
                    InkWell(
                      onTap: () async {
                        if (!(await Geolocator.isLocationServiceEnabled())) {
                          showSimpleNotification(
                              const Text(
                                "Morate uključiti svoju lokaciju!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              background: Colors.redAccent,
                              duration: Duration(seconds: 3));
                        } else {
                          _determinePosition()
                              .then((Position p) => setState(() {
                                    _center = LatLng(p.latitude, p.longitude);
                                    moveCamera(_center);
                                  }));
                        }
                      },
                      child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.my_location,
                              size: 30,
                              color: Color.fromARGB(255, 144, 159, 254),
                            )),
                      ),
                    ),
                  ],
                ),
              )),

          /* Positioned(
              //search input bar
              top: 10,
              child: InkWell(
                   onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApikey,
                        radius: 10000,
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        location: LocationWebService.Location(
                            lat: _center.latitude, lng: _center.longitude),
                        language: 'rs',
                        components: [
                          LocationWebService.Component(
                              LocationWebService.Component.country, 'rs')
                        ],
                        //google_map_webservice package
                        onError: (err) {
                          print(err);
                        });

                    if (place != null) {
                      setState(() {
                        locationSearch = place.description.toString();
                      });

                      //form google_maps_webservice package
                      final plist = LocationWebService.GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                        //from google_api_headers package
                      );
                      String placeid = place.placeId ?? "0";
                      final detail =
                          await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var newlatlang = LatLng(lat, lang);

                      //move map camera to selected place with animation
                      mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: newlatlang, zoom: 17)));
                    }
                  },
                  child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListTile(
                        title: Text(
                          locationSearch,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.search),
                        dense: true,
                      )),
                ),
              ))),*/
          Positioned(
              //search input bar
              bottom: 10,
              child: InkWell(
                  onTap: () async {
                    print("dgf");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: InkWell(
                      onTap: (() {
                        widget.callback(locationName);
                        Navigator.pop(context);
                      }),
                      child: Container(
                        child: Card(
                          shadowColor: Colors.black,
                          elevation: 5,
                          child: Container(
                            height: 60,
                            color: Color.fromARGB(255, 144, 159, 254),
                            padding: EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width - 40,
                            child: const Center(
                              child: Text(
                                'Gotovo',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))),
        ]),
      ),
    );
  }
}
