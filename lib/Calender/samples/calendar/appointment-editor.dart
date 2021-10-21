part of event_calendar;

class AppointmentEditor extends StatefulWidget {
  @override
  AppointmentEditorState createState() => AppointmentEditorState();
}

class AppointmentEditorState extends State<AppointmentEditor> {
  final apontmentxColor = Get.put(ApointmentController());
  final dirationController = Get.put(StateController());
  static final String tokenizationKey = 'sandbox_8hccj7nq_v8d2ch9m6m6bd8s6';
  var url = 'https://us-central1-tesxt-d2aa1.cloudfunctions.net/paypalPayment';
  String fname;
  String lname;
  Widget _getAppointmentEditor(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: GestureDetector(
                        child: Text(
                            DateFormat('EEE, MMM dd yyyy').format(_startDate),
                            textAlign: TextAlign.left),
                        onTap: () async {}),
                  ),
                  Expanded(
                      flex: 3,
                      child: _isAllDay
                          ? const Text('')
                          : GestureDetector(
                              child: Text(
                                DateFormat('HH:mm').format(_startDate),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {})),
                ])),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: GestureDetector(
                        child: Text(
                          DateFormat('EEE, MMM dd yyyy').format(_endDate),
                          textAlign: TextAlign.left,
                        ),
                        onTap: () async {}),
                  ),
                  Expanded(
                      flex: 3,
                      child: _isAllDay
                          ? const Text('')
                          : GestureDetector(
                              child: Text(
                                DateFormat('HH:mm').format(
                                    _selectedAppointment == null
                                        ? _endDate
                                        : _selectedAppointment.to),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {})),
                ])),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              alignment: Alignment.center,
              height: 150,
              width: 150,
              child: Transform.scale(
                  scale: 1.5,
                  child: Lottie.asset('assets/lottie/date.json',
                      repeat: false, frameRate: FrameRate(30))),
            ),
            Spacer(),
            _selectedAppointment == null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: _colorCollection[_selectedColorIndex],
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 130),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      final Meeting startTimeAppointment =
                          _isInterceptExistingAppointments(
                              _startDate, _selectedAppointment);
                      final Meeting endTimeAppointment =
                          _isInterceptExistingAppointments(
                              _endDate.subtract(Duration(minutes: 1)),
                              _selectedAppointment);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String token = prefs.getString('token');
                      fname = prefs.getString("fname");
                      lname = prefs.getString("lname");
                      String startDate =
                          DateFormat('yyyy-MM-dd HH:mm').format(_startDate);
                      var request = BraintreeDropInRequest(
                        tokenizationKey: tokenizationKey,
                        collectDeviceData: true,
                        paypalRequest: BraintreePayPalRequest(
                          amount: '10.00',
                          displayName: '$fname $lname',
                        ),
                        cardEnabled: true,
                      );

                      if (startTimeAppointment != null ||
                          endTimeAppointment != null) {
                        EasyLoading.showError(
                            "Have intercept with existing,Please select anthor time",
                            dismissOnTap: true,
                            maskType: EasyLoadingMaskType.custom);
                      } else {
                        BraintreeDropInResult result =
                            await BraintreeDropIn.start(request);
                        print(result.paymentMethodNonce.nonce);
                        print(result.deviceData);
                        if (result != null) {
                          try {
                            http.Response response = await http.post(Uri.tryParse(
                                '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}'));
                            print(response.body);
                            final payResult = jsonDecode(response.body);
                            if (payResult['result'] == 'success') {
                              print("payment done");
                              await addApointment(startDate,
                                  durationController.durationx.value, token);
                            } else {
                              EasyLoading.showError("payment faild",
                                  dismissOnTap: true,
                                  maskType: EasyLoadingMaskType.custom);
                              print("error");
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      }

                      // apontmentxColor.colorsx.value = "Color(0xFF12D9F3)";
                    },
                    child: Text(
                      "Add Apointment",
                    ),
                  )
                : Container()
          ],
        ));
  }

  @override
  Widget build([BuildContext context]) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // appBar: AppBar(
          //   title: Text(getTile()),
          //   backgroundColor: _colorCollection[_selectedColorIndex],
          //   elevation: 0,
          //   leading: IconButton(
          //     icon: const Icon(
          //       Icons.close,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          //   actions: <Widget>[
          //     IconButton(
          //         padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          //         icon: const Icon(
          //           Icons.done,
          //           color: Colors.white,
          //         ),
          //         onPressed: () async {
          //           final Meeting startTimeAppointment =
          //               _isInterceptExistingAppointments(
          //                   _startDate, _selectedAppointment);
          //           final Meeting endTimeAppointment =
          //               _isInterceptExistingAppointments(
          //                   _endDate.subtract(Duration(minutes: 1)),
          //                   _selectedAppointment);

          //           AlertDialog alert;
          //           if (startTimeAppointment != null ||
          //               endTimeAppointment != null) {
          //             Widget okButton = ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                   primary: Color(0xFF00F715)),
          //               child: Text("Ok"),
          //               onPressed: () {
          //                 Navigator.pop(context, true);
          //               },
          //             );
          //             alert = AlertDialog(
          //               title: Text("Alert"),
          //               content: Text(
          //                   'Have intercept with existing,Please select anthor time'),
          //               actions: [
          //                 okButton,
          //               ],
          //             );

          //             await showDialog<bool>(
          //               context: context,
          //               builder: (BuildContext context) {
          //                 return alert;
          //               },
          //             );

          //             return;
          //           }

          //           final List<Meeting> meetings = <Meeting>[];
          //           if (_selectedAppointment != null) {
          //             events.appointments.removeAt(
          //                 events.appointments.indexOf(_selectedAppointment));
          //             events.notifyListeners(CalendarDataSourceAction.remove,
          //                 <Meeting>[]..add(_selectedAppointment));
          //           }
          //           meetings.add(Meeting(
          //             from: _startDate,
          //             to: _endDate,
          //             background: Colors.pink,
          //             startTimeZone: _selectedTimeZoneIndex == 0
          //                 ? ''
          //                 : _timeZoneCollection[_selectedTimeZoneIndex],
          //             endTimeZone: _selectedTimeZoneIndex == 0
          //                 ? ''
          //                 : _timeZoneCollection[_selectedTimeZoneIndex],
          //             description: _notes,
          //             isAllDay: _isAllDay,
          //             eventName: _subject == '' ? '(No title)' : _subject,
          //           ));

          //           events.appointments.add(meetings[0]);

          //           events.notifyListeners(
          //               CalendarDataSourceAction.add, meetings);
          //           _selectedAppointment = null;

          //           Navigator.pop(context);
          //         })
          //   ],
          // ),
          appBar: AppBar(
            backgroundColor: _colorCollection[_selectedColorIndex],
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Stack(
              children: <Widget>[_getAppointmentEditor(context)],
            ),
          ),
        ));
  }

  // String getTile() {
  //   return _subject.isEmpty ? 'New event' : 'Event details';
  // }

  dynamic _isInterceptExistingAppointments(
      DateTime date, Meeting selectedAppointment) {
    if (date == null ||
        events == null ||
        events.appointments == null ||
        events.appointments.isEmpty) return null;
    for (int i = 0; i < events.appointments.length; i++) {
      var appointment = events.appointments[i];
      if (appointment != selectedAppointment &&
          (date.isAfter(appointment.from) ||
              _isSameDateTime(date, appointment.from)) &&
          date.isBefore(appointment.to)) {
        return appointment;
      }
    }
    return null;
  }

  bool _isSameDateTime(DateTime date1, DateTime date2) {
    if (date1 == date2) {
      return true;
    }

    if (date1 == null || date2 == null) {
      return false;
    }

    if (date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day &&
        date1.hour == date2.hour &&
        date1.minute == date2.minute) {
      return true;
    }

    return false;
  }

  Future addApointment(
    String time,
    int duration,
    String token,
  ) async {
    try {
      EasyLoading.show(
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.custom,
      );
      http.Response response = await http.post(
        Uri.parse(
            'http://www.bergischreinigung.de/ap.php?type=add-date&start_time=$time&token=$token&duration=$duration'),
      );
      var result = jsonDecode(response.body);
      print(result);
      if (result[0]['status'] == "1") {
        EasyLoading.showSuccess(
          "yor appointment has been added",
          dismissOnTap: false,
          maskType: EasyLoadingMaskType.custom,
        );
        Timer(Duration(microseconds: 2000), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        });
      } else {
        EasyLoading.showError(
          "error, appointment not added , please connect with us",
          dismissOnTap: false,
          maskType: EasyLoadingMaskType.custom,
          duration: Duration(microseconds: 1900),
        );
        Timer(Duration(microseconds: 2000), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
