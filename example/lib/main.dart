import 'package:example/SearchDataDetails.dart';
import 'package:flutter/material.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:json_tree_viewer/json_tree_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geocoder Buddy Example',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Geocoder Buddy Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchTextController = TextEditingController();
  final latTextController = TextEditingController();
  final lngTextController = TextEditingController();
  List<GBSearchData> searchItem = [];
  Map<String, dynamic> details = {};
  bool isSearching = false;
  bool isLoading = false;

  void searchLocation(String query) async {
    setState(() {
      isSearching = true;
    });
    List<GBSearchData> data = await GeocoderBuddy.query(query);
    setState(() {
      isSearching = false;
      searchItem = data;
    });
  }

  getAddressDetails(GBLatLng pos) async {
    setState(() {
      isLoading = true;
    });
    GBData data = await GeocoderBuddy.findDetails(pos);
    setState(() {
      isLoading = false;
      details = data.toJson();
    });
    print(data.address.village);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Search Location",
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: searchTextController,
                  decoration: const InputDecoration(
                      hintText: "Search Location",
                      border: OutlineInputBorder()),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (searchTextController.text.isNotEmpty) {
                      searchLocation(searchTextController.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please Enter Location")));
                    }
                  },
                  child: Text("Search")),
              SizedBox(
                height: 300,
                child: !isSearching
                    ? ListView.builder(
                        itemCount: searchItem.length,
                        itemBuilder: (context, index) {
                          var item = searchItem[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SearchDataDetails(
                                            data: item,
                                          )));
                            },
                            title: Text(item.displayName),
                          );
                        })
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Lat/Lng to Details",
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: latTextController,
                  decoration: const InputDecoration(
                      hintText: "Latitude", border: OutlineInputBorder()),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: lngTextController,
                  decoration: const InputDecoration(
                      hintText: "Longitude", border: OutlineInputBorder()),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (latTextController.text.isNotEmpty &&
                        lngTextController.text.isNotEmpty) {
                      GBLatLng pos = GBLatLng(
                          lat: double.parse(latTextController.text),
                          lng: double.parse(lngTextController.text));
                      getAddressDetails(pos);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please Enter Lat/Lng")));
                    }
                  },
                  child: const Text("Get Details")),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 300,
                child: !isLoading
                    ? JsonTreeViewer(
                        data: details,
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
