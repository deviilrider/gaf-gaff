import 'package:flutter/material.dart';
import 'package:gafgaff/constants/strings.dart';
import 'package:gafgaff/models/call.dart';
import 'package:gafgaff/models/log.dart';
import 'package:gafgaff/resources/call_methods.dart';
import 'package:gafgaff/resources/local_db/repository/log_repository.dart';
import 'package:gafgaff/screens/callscreens/call_screen.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/utils/permissions.dart';
import 'package:gafgaff/widgets/circular_button.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  // final LogRepository logRepository = LogRepository(isHive: true);
  // final LogRepository logRepository = LogRepository(isHive: false);

  bool isCallMissed = true;

  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming Call...",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: size.height * 0.1),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 100,
            ),
            SizedBox(height: 20),
            Text(
              widget.call.callerName.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: size.height * 0.25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircularButton(
                  onTap: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                  size: 40,
                  icon: Icons.call_end,
                  iconColor: Colors.redAccent,
                ),
                SizedBox(width: 25),
                CircularButton(
                  onTap: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CallScreen(call: widget.call),
                            ),
                          )
                        : {};
                  },
                  size: 40,
                  icon: Icons.call,
                  iconColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
