import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RouteDrawPage(),
    );
  }
}

class RouteDrawPage extends StatefulWidget {
  const RouteDrawPage({super.key});

  @override
  State<RouteDrawPage> createState() => _RouteDrawPageState();
}

class _RouteDrawPageState extends State<RouteDrawPage> {
  Point source = const Point(latitude: 41.2858305, longitude: 69.2035464);
  Point destination = const Point(latitude: 41.341267, longitude: 69.163425);
  var route = const PolylineMapObject(
      mapId: MapObjectId('route'), polyline: Polyline(points: []));

  YandexMapController? mapController;

  
Future <void> getRoute()async{
  final routeRequest = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
            point: source,
            requestPointType: RequestPointType.wayPoint
        ),
        RequestPoint(
            point: destination,
            requestPointType: RequestPointType.wayPoint
        ),
      ], drivingOptions: DrivingOptions(initialAzimuth: 0,routesCount: 5,avoidTolls: true),
  );
  final result = await routeRequest.result;
  route = PolylineMapObject(mapId: MapObjectId('route'),
      strokeColor: Colors.red,
      strokeWidth: 3,
      polyline: Polyline(
    points: result.routes?.first.geometry??[]
  ));
  setState(() {

  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        mapObjects: [
          CircleMapObject(
              mapId: MapObjectId('source'),
              fillColor: Colors.blue.withOpacity(.3),
              strokeColor: Colors.blue,
              circle: Circle(center: source, radius: 20)),
          PlacemarkMapObject(
              mapId: MapObjectId('destination'),
              point: destination,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/images/profille.png'),
                  scale: 0.5))),
          route,
        ],
        onCameraPositionChanged: (cameraPosition, reason, finished) {},
        onMapCreated: (controller) async {
          mapController = controller;
          await controller.moveCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: source, zoom: 12),
          ));
          await getRoute();
        },
      ),
    );
  }
}
