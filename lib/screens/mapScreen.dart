import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/screens/placeInformScreen.dart';
import 'package:zhardem/widgets/saveElevatedButton.dart';

import '../models/placeModel.dart';
import '../services/placeService.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  var logger = Logger(
    printer: PrettyPrinter()
  );

  List<PlaceModel> places =[];

  void getAllPlaces() async{
    try{
      final ap = Provider.of<PlaceService>(context,listen: false);
      places = await ap.getAllPlaces();

      logger.i("ap.getAllPlaces успешно выполнена");
    }
    catch(e){
      logger.e("Что то пошло не так при получении данных $e");
    }
  }


  @override
  void initState() {
    super.initState();
    getAllPlaces();
  }

  void _showModalBottomSheet(BuildContext context, PlaceModel place) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (place.imageUrl != null && place.imageUrl.isNotEmpty)
                Image.network(
                  place.imageUrl[0], // First URL from the list
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16),
              Text(
                place.name ?? '', // Handling possible null value
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                place.description ?? '', // Handling possible null value
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              SaveElevatedButton(
                height: 50,
                text: "Перейти на страницу информации",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlaceInformScreen(
                        placeId: place.id,
                        collectionName: 'places',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PlaceModel>>(
        // Получаем все места
        future: PlaceService().getAllPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Показываем индикатор загрузки, пока идет загрузка данных
          } else if (snapshot.hasError) {
            return Text('Ошибка загрузки данных: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Если данных нет или они пусты, просто отобразим карту
            return FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(43.25, 76.95),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
              ],
            );
          } else {
            // Если есть данные, отобразим карту с маркерами для каждого места
            return FlutterMap(
              options: const MapOptions(
                center: LatLng(43.25, 76.95),
                zoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                markers: places.map((e) => Marker(
                    point: LatLng(e.locationLat,e.locationLng),
                    child: GestureDetector(
                      child: Icon(Icons.location_pin),
                      onTap: (){
                        _showModalBottomSheet(context, e);
                      },
                    )
                )).toList(),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
