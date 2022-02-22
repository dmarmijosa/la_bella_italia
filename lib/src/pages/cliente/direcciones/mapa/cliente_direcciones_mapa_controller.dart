import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart';

class ClienteDireccionesMapaController {
  BuildContext context;
  Function refresh;
  Position _position;
  String addressName;
  LatLng addressLatLng;

  CameraPosition positionInit =
      CameraPosition(target: LatLng(40.0025746, 3.8412286), zoom: 19.27);

  Completer<GoogleMapController> _mapController = Completer();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    refresh();
    checkGPS();
  }

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng.latitude,
      'long': addressLatLng.longitude
    };
    Navigator.pop(context, data);
  }

  Future<Null> setLocalizacionInfo() async {
    if (positionInit != null) {
      double lat = positionInit.target.latitude;
      double lng = positionInit.target.longitude;
      try {
        List<Placemark> address = await placemarkFromCoordinates(lat, lng);
        if (address != null) {
          if (address.length > 0) {
            String direction = address[0].thoroughfare;
            String street = address[0].subThoroughfare;
            String city = address[0].locality;
            String department = address[0].administrativeArea;
            addressName = '$direction #$street, $city, $department';
            addressLatLng = new LatLng(lat, lng);

            refresh();
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void onMapCreate(GoogleMapController controller) {
    try {
      _mapController.complete(controller);
    } catch (e) {
      print(e);
    }
  }

  void checkGPS() async {
    bool localizacionActivada = await Geolocator.isLocationServiceEnabled();
    if (localizacionActivada) {
      updateLocations();
    } else {
      bool localizacionGps = await location.Location().requestService();
      if (localizacionGps) {
        updateLocations();
      }
    }
  }

  void updateLocations() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      goToPosition(_position.latitude, _position.longitude);
    } catch (e) {
      print(e);
    }
  }

  Future goToPosition(double lat, double log) async {
    try {
      GoogleMapController controller = await _mapController.future;
      if (controller != null) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, log), zoom: 18, bearing: 0),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // ignore: missing_return
  Future<Position> _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }

        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print(e);
    }
  }
}
