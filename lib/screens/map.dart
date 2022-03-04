import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_register_ui/api/auth_service.dart';
import 'package:flutter_login_register_ui/widgets/widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'snap.dart';

class MapPage extends StatefulWidget {
  final int situation; 
  MapPage({this.situation});
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  static final LatLng _mapCenter = LatLng(25.359754, 51.190460);
  static final CameraPosition _initialPosition = CameraPosition(target: _mapCenter, zoom: 9.0, tilt: 0, bearing: 0);
  String _darkMapStyle;
  String _lightMapStyle;
  bool showNext = false;
  LatLng chosenLocation;
  Position location;
  BitmapDescriptor customIcon;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers; 

  @override
  void initState() {
    super.initState();
    _markers = Set<Marker>();
    _getLocation();
    _loadIcons();
    _loadMapStyles();
  }

  Future _getLocation() async {
    location = await Geolocator.getCurrentPosition();
    chosenLocation = LatLng(location.latitude,location.longitude);
    setState(() {
      _markers = Set<Marker>();
      _markers.add(Marker(
        markerId: MarkerId(chosenLocation.toString()),
        position: chosenLocation,
        infoWindow: InfoWindow(
          title: 'Help',
        ),
        icon: customIcon,
      ));
    });
    if(!showNext) showNext = true;
  }
  
  Future _loadMapStyles() async {
    _darkMapStyle  = await rootBundle.loadString('assets/map/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/map/light.json');
  }

  Future _loadIcons() async {
    customIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/map/emergency1.png');
  }

  handleTap(LatLng point){
    if(!showNext) showNext = true;
    setState(() {
      _markers = Set<Marker>();
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'Help',
        ),
        icon: customIcon,
      ));
      chosenLocation = point;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            color: Colors.white,
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
            child : Stack(
              children: [
                GoogleMap(
                    initialCameraPosition: _initialPosition,
                    markers: _markers,
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(_lightMapStyle);
                    },
                    onTap: handleTap,
                  ),
                  (showNext) ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: MyTextButton(
                        buttonName: AppLocalizations.of(context).takeasnapshot,
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Snap(situation : widget.situation, location: chosenLocation),
                              ));
                          },
                        bgColor: Colors.blueGrey,
                        textColor: Colors.white,
                      ),
                    ),
                  ) : SizedBox(),
              ],
            ), 
      )
    );
  }
}