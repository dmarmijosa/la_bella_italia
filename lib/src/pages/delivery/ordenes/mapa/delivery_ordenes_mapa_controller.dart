import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_bella_italia/src/api/enviroments.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:la_bella_italia/src/models/orden.dart';

class DeliveryOrdenesMapaController {
  BuildContext context;
  Function refresh;
  Position _posicion;
  String addressName;
  LatLng addressLatLng;
  Orden orden;
  StreamSubscription _posicionStream;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  BitmapDescriptor deliveryMarker;
  BitmapDescriptor homeMarker;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CameraPosition posicionIncial =
      CameraPosition(target: LatLng(40.0025746, 3.8412286), zoom: 19.27);

  Completer<GoogleMapController> _mapController = Completer();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    orden = Orden.fromJson(
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>);

    deliveryMarker = await createMarkerFromAsset('assets/img/delivery.png');
    homeMarker = await createMarkerFromAsset('assets/img/home.png');

    print('ORDEN: ${orden.toJson()}');
    refresh();
    checkGPS();
  }

  Future<void> setPolylines(LatLng de, LatLng hacia) async {
    PointLatLng pointDe = PointLatLng(de.latitude, de.longitude);
    PointLatLng pointHacia = PointLatLng(hacia.latitude, hacia.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Enviroments.API_KEY_GOOGLE, pointDe, pointHacia);
    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: MyColors.primaryColor,
      points: points,
      width: 6,
    );
    polylines.add(polyline);
    refresh();
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );

    markers[id] = marker;

    refresh();
  }

  void selectRefPunto() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng.latitude,
      'long': addressLatLng.longitude
    };
    Navigator.pop(context, data);
  }

  Future<BitmapDescriptor> createMarkerFromAsset(String path) async {
    final Uint8List markerIcon = await getBytesFromAsset(path, 150);
    BitmapDescriptor descriptor = await BitmapDescriptor.fromBytes(markerIcon);

    return descriptor;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<Null> SetLocalizacionInfo() async {
    if (posicionIncial != null) {
      double lat = posicionIncial.target.latitude;
      double lng = posicionIncial.target.longitude;
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

  void dispose() {
    _posicionStream?.cancel();
  }

  void onMapCrear(GoogleMapController controller) {
    try {
      _mapController.complete(controller);
    } catch (e) {
      print(e);
    }
  }

  void checkGPS() async {
    bool localizacionActivada = await Geolocator.isLocationServiceEnabled();
    if (localizacionActivada) {
      actualizaLocalizacion();
    } else {
      bool localizacionGps = await location.Location().requestService();
      if (localizacionGps) {
        actualizaLocalizacion();
      }
    }
  }

  void actualizaLocalizacion() async {
    try {
      await _determinePosition();
      _posicion = await Geolocator.getLastKnownPosition();
      iraPosicion(_posicion.latitude, _posicion.longitude);
      addMarker(
        'delivery',
        _posicion.latitude,
        _posicion.longitude,
        'Tu posición',
        '',
        deliveryMarker,
      );
      addMarker(
        'HOME',
        orden.address.lat,
        orden.address.lng,
        'Lugar de entrega',
        '',
        homeMarker,
      );
    } catch (e) {
      print(e);
    }
    LatLng de = new LatLng(_posicion.latitude, _posicion.longitude);
    LatLng hacia = new LatLng(orden.address.lat, orden.address.lng);
    setPolylines(de, hacia);

    _posicionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
        .listen((Position position) {
      _posicion = position;
      addMarker(
        'delivery',
        _posicion.latitude,
        _posicion.longitude,
        'Tu posición',
        '',
        deliveryMarker,
      );
      iraPosicion(_posicion.latitude, _posicion.longitude);
      refresh();
    });
  }

  Future iraPosicion(double lat, double log) async {
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
