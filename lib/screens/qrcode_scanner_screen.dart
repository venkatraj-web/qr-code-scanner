import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  late Size size;

  final GlobalKey _qrKey = GlobalKey(debugLabel: "QR");

  QRViewController? _controller;
  Barcode? result;

  bool _isBuild = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    //So we are having multiple dialogs. Let's fix it

    if(!_isBuild && _controller != null){
      _controller?.pauseCamera();
      _controller?.resumeCamera();
      setState(() {
        _isBuild = true;
      });
    }


    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("QrCode Scanner")),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(flex: 9, child: _buidQrView(context)),
            Expanded(
                flex: 1,
                child: Container(
                  color: Color(0xffe3dfdf),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            await _controller?.toggleFlash();
                          },
                          child: Icon(
                            Icons.flash_on,
                            size: 24,
                            color: Color(0xffF7524F),
                          )),
                      GestureDetector(
                        onTap: () async {
                          await _controller?.flipCamera();
                        },
                        child: Icon(
                          Icons.flip_camera_ios,
                          size: 24,
                          color: Color(0xffF7524F),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buidQrView(BuildContext context) {
    // let's get package for qr scanner

    // let's define a small area for scanning

    var scanArea = 250.0;

    return QRView(
      key: _qrKey,
      onQRViewCreated: onQRViewCreated,
      onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
      overlay: QrScannerOverlayShape(
          cutOutSize: scanArea,
          borderWidth: 10,
          borderRadius: 5.0,
          borderLength: 40,
          borderColor: Color(0xffF7524F)),
    );
  }

  void onQRViewCreated(QRViewController _qrController) {
    setState(() {
      this._controller = _qrController;
    });

    _controller!.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        _controller?.pauseCamera();
      });

      if(result?.code != null){
        print("QR code Scanned and showing Result");
        _showResult();
      }
    });
  }

  void onPermissionSet(
      BuildContext context, QRViewController _ctrl, bool _permission) {
    if (!_permission) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No Permission")));
    }
  }

  //Creating a result value
  Widget _showResult() {
    //Now check if it is url or not, if url then launch it.

    bool _validURL = Uri.parse(result!.code.toString()).isAbsolute;

    return Center(
      child: FutureBuilder<dynamic>(
        future: showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                title: Text(
                  "Scan Result!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  height: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _validURL ?
                          SelectableText.rich(TextSpan(
                            text: result!.code.toString(),
                            style: TextStyle(
                              color: Color(0xffF7524F)
                            ),
                            recognizer: TapGestureRecognizer()..onTap=(){
                              launchUrl(Uri.parse(result!.code.toString()));
                            }
                          )) :
                      Text(
                        result!.code.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _controller?.resumeCamera();
                        },
                        child: Text("Close"),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),
                          shadowColor: Colors.deepPurple
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onWillPop: () async => false,
            );
          },
        ),
        builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot) {
          throw UnimplementedError;
        },
      ),
    );
  }
}
