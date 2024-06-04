import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlaceInformScreen extends StatelessWidget {
  final String placeId;
  final String collectionName;

  const PlaceInformScreen({Key? key, required this.placeId, required this.collectionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection(collectionName).doc(placeId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData) {
        return Text('ошибочка');
      }

      final placeData = snapshot.data!.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic>
      if (placeData == null) {
        return Text('Список пуст');
      }

      final String name = placeData['name'] as String ;
      final String description = placeData['description'] as String;
      final List<String> imageUrls = List<String>.from(placeData['imageUrl'] ?? []);
      final double locationLat = placeData['locationLat'] as double;
      final double locationLng = placeData['locationLng'] as double;


      return Scaffold(

        appBar: AppBar(
          title: Text(name),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),

        body: Column(
          children: [
            Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: imageUrls.length,
                        itemBuilder: (BuildContext context, int imageIndex) {
                          return Image.network(
                            imageUrls[imageIndex],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),

      );
    }


    );
  }
}
