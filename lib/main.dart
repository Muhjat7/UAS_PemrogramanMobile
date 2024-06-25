import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'payment_page.dart';

class Station {
  final String name;
  final String city;
  final String province;

  Station({required this.name, required this.city, required this.province});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Ticket Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StationsPage(),
    );
  }
}

class StationsPage extends StatefulWidget {
  @override
  _StationsPageState createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  late Future<List<Station>> _stationData;
  List<Station> _filteredStations = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stationData = fetchStationData();
  }

  Future<List<Station>> fetchStationData() async {
    final response =
        await http.get(Uri.parse('https://booking.kai.id/api/stations2'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Station> stations = [];
      for (var station in data) {
        stations.add(Station(
          name: station['name'] ?? '',
          city: station['city'] ?? '',
          province: station['province'] ?? '',
        ));
      }
      return stations;
    } else {
      throw Exception('Failed to fetch station data');
    }
  }

  void _filterStations(String keyword) {
    setState(() {
      _filteredStations = [];
      _stationData.then((stations) {
        _filteredStations = stations
            .where((station) =>
                station.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Train Stations'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filterStations,
              decoration: InputDecoration(
                labelText: 'Search by Station Name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Station>>(
                future: _filteredStations.isNotEmpty
                    ? Future.value(_filteredStations)
                    : _stationData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.train),
                            title: Text(snapshot.data![index].name),
                            subtitle: Text(
                                '${snapshot.data![index].city}, ${snapshot.data![index].province}'),
                            trailing: ElevatedButton(
                              child: Text('Book'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingPage(
                                      station: snapshot.data![index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "${snapshot.error}",
                       
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  final Station station;

  BookingPage({required this.station});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking - ${widget.station.name}'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Departure Date',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Select Date'),
              onPressed: () {
                _selectDate(context);
              },
            ),
            SizedBox(height: 16),
            Text(
              'Selected Date: ${_selectedDate.toString().split(' ')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Proceed to Payment'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      station: widget.station,
                      departureDate: _selectedDate,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
