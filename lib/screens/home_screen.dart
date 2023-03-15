import 'package:flutter/material.dart';
import 'package:qrcode_scanner/screens/check_permission_screen.dart';

import 'qrcode_scanner_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("QR Code Scanner & Generator")),
      body: Container(
        color: Colors.brown,
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 200,
              child: ElevatedButton(onPressed: () { 
                Navigator.push(context, MaterialPageRoute(builder: (context) => QrCodeScannerScreen()));
              },
              child: const Text("Scan QR code"),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                shadowColor: Colors.deepPurple
              )),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 40,
              width: 200,
              child: ElevatedButton(onPressed: () {  },
                child: const Text("Generate QR code"),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  )
              ),),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 40,
              width: 200,
              child: ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => CheckPermissionScreen()));
              },
                child: const Text("Check All Permissions"),
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
