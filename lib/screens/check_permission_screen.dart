import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:camera/camera.dart';

class CheckPermissionScreen extends StatefulWidget {
  const CheckPermissionScreen({Key? key}) : super(key: key);

  @override
  State<CheckPermissionScreen> createState() => _CheckPermissionScreenState();
}

class _CheckPermissionScreenState extends State<CheckPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checking Permission"),),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Center(child: ElevatedButton(onPressed: checkpermission_opencamera, child: Text("Camera"))),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  checkpermission_opencamera() async {
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;

    print(cameraStatus);
    print(microphoneStatus);
    //cameraStatus.isGranted == has access to application
    //cameraStatus.isDenied == does not have access to application, you can request again for the permission.
    //cameraStatus.isPermanentlyDenied == does not have access to application, you cannot request again for the permission.
    //cameraStatus.isRestricted == because of security/parental control you cannot use this permission.
    //cameraStatus.isUndetermined == permission has not asked before.

    if(!cameraStatus.isGranted){
      AppSettings.openAppSettings();
      // await Permission.camera.request();
    }
    if(!microphoneStatus.isGranted){
      await Permission.microphone.request();
    }
  }
}
