import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:flutter_login_register_ui/widgets/widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapRoute extends StatefulWidget {
  Post post;
  MapRoute({this.post});
  MapRoute.fromDestination(LatLng destination) {
    this.post = Post();
    post.position = destination;
  }
  @override
  MapRouteState createState() => MapRouteState();
}

class MapRouteState extends State<MapRoute> {
  static LatLng _mapCenter ;//LatLng(25.359754, 51.190460);
  static final CameraPosition _initialPosition = CameraPosition(target: _mapCenter, zoom: 9.0, tilt: 0, bearing: 0);
  bool accpeted = false, done = false;
  String _darkMapStyle;
  String _lightMapStyle;
  bool showNext = false;
  LatLng chosenLocation;
  BitmapDescriptor customIcon, locationIcon;
  var _controller ;
  Set<Marker> _markers; 
  Position _location;
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    accpeted = widget.post.accepted;
    _mapCenter = widget.post.position;
    _loadIcons();
    _loadMapStyles();
    _getLocation();
    _markers = Set<Marker>();
    _markers.add(Marker(
      markerId: MarkerId("destination"),
      position: widget.post.position,
      infoWindow: InfoWindow(
          title: 'Help',
      ),
      )
    );
  }

  Future _getLocation() async {
    _location = await Geolocator.getCurrentPosition();
  }

  Future _loadMapStyles() async {
    _darkMapStyle  = await rootBundle.loadString('assets/map/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/map/light.json');
  }

  Future _loadIcons() async {
    customIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/map/dest.png');
    locationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/map/dest.png');
  }

  setPolylines() async {   
    _polylines.clear();
    polylineCoordinates.clear();
    PolylineResult result = await
      polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDxVaX0qzgkLp1DUl7IMmscWDGECFlWpaU",
         PointLatLng(_location.latitude,_location.longitude),PointLatLng(widget.post.position.latitude,widget.post.position.longitude),
         travelMode: TravelMode.driving);
      print(result.points);   
      if(result.points.isNotEmpty){ 
          result.points.forEach((PointLatLng point){
            polylineCoordinates.add(
                LatLng(point.latitude, point.longitude));
          });
      }   
      setState(() {
        Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates
        );
        _polylines.add(polyline);
      });
}

void setPins() async{   
  if(_location == null)
    await _getLocation();
  setState((){
      // destination pin
      _markers.add(Marker(
         markerId: MarkerId("destPin"),
         position: widget.post.position,
      ));   
  });
}

  void _onMapCreated(GoogleMapController _cntlr) async {
    _cntlr.setMapStyle(_lightMapStyle);
    _controller = _cntlr;
    setPins();
    Geolocator.getPositionStream().listen(
        (Position position) {
            _location = position;
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(_location.latitude, _location.longitude),zoom: 15),
        );
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
                    polylines: _polylines,
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                  ),
                  (Api.mode == modes.CUSTIOMER) ? 
                  (!done) ? 
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 140,
                        height: 50,
                        child: MyTextButton(
                        buttonName: "Done", 
                        onTap: () async {
                          Api api = Api();
                          print(accpeted);
                          if (accpeted){
                            print('removing');
                            await api.doneAccepted(widget.post).then((value) => done = true).onError((error, stackTrace) => null);
                            print('removed');
                          }
                          else 
                            await api.done(widget.post).then((value) => done = true).onError((error, stackTrace) => null);
                          setState(() {
                            
                          });
                          Navigator.pop(context);
                          }, 
                        bgColor: Colors.blue, 
                        textColor: Colors.white
                        ),
                      ),
                    ),
                  ): SizedBox() :
                  (!accpeted) ? 
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 140,
                        height: 50,
                        child: MyTextButton(
                        buttonName: "Accept", 
                        onTap: () async {
                          Api api = Api();
                          await api.accept(widget.post).then((value) => accpeted = true).onError((error, stackTrace) => null);
                          setPolylines();
                          setState(() {
                            
                          });
                          }, 
                        bgColor: Colors.green, 
                        textColor: Colors.white
                        ),
                      ),
                    ),
                  ): SizedBox()
              ],
            ), 
      )
    );
  }
}