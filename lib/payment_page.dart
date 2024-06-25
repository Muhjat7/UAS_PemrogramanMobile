import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final station;
  final DateTime departureDate;

  PaymentPage({required this.station, required this.departureDate});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Center(
              child: Text(
                'Payment Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Station: ${widget.station.name}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Center(
              child: Text(
                'Departure Date: ${widget.departureDate.toString().split(' ')[0]}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Text(
                'Select Payment Option:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildPaymentOption('MANDIRI', 'Transfer via MANDIRI', Icons.payment),
                  SizedBox(width: 16),
                  buildPaymentOption('BNI', 'Transfer via BNI', Icons.payment),
                  SizedBox(width: 16),
                  buildPaymentOption('BRI', 'Transfer via BRI', Icons.payment),
                ],
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Confirm Payment'),
                onPressed: () {
                  // Handle payment confirmation logic here
                  print('Selected Payment Option: $selectedPaymentOption');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentConfirmationPage(
                        selectedPaymentOption: selectedPaymentOption,
                        stationName: widget.station.name,
                        departureDate: widget.departureDate,
                        bookingPrice: 150000.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentOption(String title, String subtitle, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentOption = title;
        });
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedPaymentOption == title ? Colors.blue : Colors.transparent,
              border: Border.all(
                color: selectedPaymentOption == title ? Colors.blue : Colors.grey,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 40,
              color: selectedPaymentOption == title ? Colors.white : Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: selectedPaymentOption == title ? Colors.blue :
Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentConfirmationPage extends StatefulWidget {
  final String selectedPaymentOption;
  final String stationName;
  final DateTime departureDate;
  final double bookingPrice;

  PaymentConfirmationPage({
    required this.selectedPaymentOption,
    required this.stationName,
    required this.departureDate,
    required this.bookingPrice,
  });

  @override
  _PaymentConfirmationPageState createState() => _PaymentConfirmationPageState();
}

class _PaymentConfirmationPageState extends State<PaymentConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Confirmation'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payment,
                      size: 24,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Ticket Detail Booking',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                buildInfoRow('Payment', widget.selectedPaymentOption, Icons.payment),
                SizedBox(height: 16),
                buildInfoRow('Station', widget.stationName, Icons.location_on),
                SizedBox(height: 16),
                buildInfoRow('Departure Date', widget.departureDate.toString().split(' ')[0], Icons.calendar_today),
                SizedBox(height: 16),
                buildInfoRow('Booking Price', 'Rp ${widget.bookingPrice.toStringAsFixed(0)}', Icons.attach_money),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.grey,
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentPage(
        station: Station(name: 'Station A'),
        departureDate: DateTime.now(),
      ),
    );
  }
}

class Station {
  final String name;

  Station({required this.name});
}
