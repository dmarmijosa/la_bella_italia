import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_bella_italia/src/api/enviroments.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/order_provider.dart';
import 'package:la_bella_italia/src/providers/pushNotification_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:la_bella_italia/src/models/order.dart';

class DeliveryOrdenesMapaController {
  BuildContext context;
  Function refresh;
  OrderProvider _orderProvider = new OrderProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  Position _posicion;
  String addressName;
  LatLng addressLatLng;
  Order orden;
  StreamSubscription _posicionStream;
  double _distance;

  IO.Socket socket;

  List<LatLng> points = [];

  BitmapDescriptor deliveryMarker;
  BitmapDescriptor homeMarker;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CameraPosition positionInitial =
      CameraPosition(target: LatLng(40.0025746, 3.8412286), zoom: 19.27);

  Completer<GoogleMapController> _mapController = Completer();
  PushNotificationProvider pushNotificationsProvider =
      new PushNotificationProvider();
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user'));

    orden = Order.fromJson(
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>);

    deliveryMarker = await createMarkerFromAsset('assets/img/delivery.png');
    homeMarker = await createMarkerFromAsset('assets/img/home.png');

    socket = IO.io(
        'http://${Enviroments.API_DELIVERY}/orders/delivery', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket.connect();

    _orderProvider.init(context, user);

    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    refresh();

    checkGPS();
  }

  void emitPosition() {
    socket.emit('position', {
      'id_order': orden.id,
      'lat': _posicion.latitude,
      'lng': _posicion.longitude,
    });
  }

  void launchGoogleMaps() async {
    var url =
        'google.navigation:q=${orden.address.lat.toString()},${orden.address.lng.toString()}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${orden.address.lat.toString()},${orden.address.lng.toString()}';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void positionClose() {
    _distance = Geolocator.distanceBetween(
      _posicion.latitude,
      _posicion.longitude,
      orden.address.lat,
      orden.address.lng,
    );
    sendNotification(orden.client.notificationToken);
  }

  void updateDelivered() async {
    if (_distance <= 100) {
      ResponseApi responseApi = await _orderProvider.updateToDelivered(orden);
      if (responseApi.success) {
        sendNotificationDeliveryinSite(orden.client.notificationToken);
        Fluttertoast.showToast(
            msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
        Navigator.pushNamedAndRemoveUntil(
            context, 'delivery/ordenes/lista', (route) => false);
      }
    } else {
      MyScnackbar.show(context, 'Debe estar mas cerca del lugar de entrega');
    }
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
    // ignore: await_only_futures
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

  Future<Null> setLocalizacionInfo() async {
    if (positionInitial != null) {
      double lat = positionInitial.target.latitude;
      double lng = positionInitial.target.longitude;
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
    socket?.disconnect();
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
      updateLocation();
    } else {
      bool localizacionGps = await location.Location().requestService();
      if (localizacionGps) {
        updateLocation();
      }
    }
  }

  void sendNotification(String tokenDelivery) {
    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    pushNotificationsProvider.sendMessage(
        tokenDelivery,
        data,
        'REPARTIDOR ACERCANDOSE',
        'Tu repartidor esta cerca al lugar de entrega');
  }

  void sendNotificationDeliveryinSite(String tokenDelivery) {
    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    pushNotificationsProvider.sendMessage(
        tokenDelivery,
        data,
        'TU REPARTIDOR HA LLEGADO',
        'Tu repartidor esta en el lugar de entrega');
  }

  void saveLocation() async {
    orden.lat = _posicion.latitude;
    orden.lng = _posicion.longitude;

    await _orderProvider.updatelatLng(orden);
    refresh();
  }

  void updateLocation() async {
    try {
      await _determinePosition(); // OBTENER LA POSICION ACTUAL Y TAMBIEN SOLICITAR LOS PERMISOS
      _posicion = await Geolocator.getLastKnownPosition(); // LAT Y LNG
      saveLocation();

      goToPosition(_posicion.latitude, _posicion.longitude);
      addMarker('delivery', _posicion.latitude, _posicion.longitude,
          'Tu posicion', '', deliveryMarker);

      addMarker('home', orden.address.lat, orden.address.lng,
          'Lugar de entrega', '', homeMarker);

      _posicionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) {
        _posicion = position;

        emitPosition();

        addMarker('delivery', _posicion.latitude, _posicion.longitude,
            'Tu posicion', '', deliveryMarker);

        goToPosition(_posicion.latitude, _posicion.longitude);
        positionClose();

        refresh();
      });
    } catch (e) {
      print('Error: $e');
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
      refresh();
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
