import 'dart:async';
import 'dart:convert';

import 'package:cleanx/const/colors.dart';
import 'package:cleanx/controller.dart/appointmentC.dart';
import 'package:cleanx/Calender/samples/calendar/DView.dart';
import 'package:cleanx/controller.dart/stateController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:http/http.dart' as http;
import '../../model/model.dart';
import '../../model/sample_view.dart';

class CalendarAppointmentEditor extends SampleView {
  @override
  _CalendarAppointmentEditorState createState() =>
      _CalendarAppointmentEditorState();
}

class _CalendarAppointmentEditorState extends SampleViewState {
  final apontmentxx = Get.put(ApointmentController());
  final durationController = Get.put(StateController());
  var navigteData;
  int counter;
  _CalendarAppointmentEditorState();
  final List<Appointment> appointment = <Appointment>[];
  List<String> _subjectCollection;
  List<Appointment> _appointments;
  // ignore: unused_field
  bool _isMobile;
  List<Color> _colorCollection;
  List<String> _colorNames;
  // ignore: unused_field
  int _selectedColorIndex = 0;
  List<String> _timeZoneCollection;
  _DataSource _events;
  // ignore: unused_field
  Appointment _selectedAppointment;
  // ignore: unused_field
  bool _isAllDay = false;
  // ignore: unused_field
  String _subject = '';
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
  ];
  final ScrollController controller = ScrollController();
  final CalendarController calendarController = CalendarController();
  CalendarView _view = CalendarView.month;
  @override
  void initState() {
    apontmentxx.datex.value = DateTime.now();
    // getFirebaseToken();
    getTravleName();
    // getToken();
    addpoint();
    _isMobile = false;
    calendarController.view = _view;

    _events = _DataSource(_appointments);
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _subject = '';
    super.initState();
  }

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String token = value;
      print(token);
    });
  }

  @override
  void didChangeDependencies() {
    _isMobile = MediaQuery.of(context).size.width < 767;
    super.didChangeDependencies();
  }

  Future getTravleName() async {
    EasyLoading.show(
      dismissOnTap: true,
      maskType: EasyLoadingMaskType.custom,
    );
    try {
      http.Response response = await http.get(Uri.parse(
          'http://www.bergischreinigung.de/ap.php?type=get-all-dates'));
      print(response.body);
      var result = jsonDecode(response.body);

      if (result != null) {
        // List<DateTime> listDT = [];
        int length = result.length;
        // print(length);
        // for (int i = 0; i < length; i++) {
        //   listDT.add(DateTime.parse(result[i]['start_time']));
        // }
        // listDT.sort((a, b) => a.compareTo(b));

        result.sort((a, b) {
          return DateTime.parse(a["start_time"])
              .compareTo(DateTime.parse(b["start_time"]));
        });
        for (int i = 0; i < length; i++) {
          // print(result[i]['start_time']);
          DateTime dt = DateTime.parse(result[i]['start_time']);
          // int duration = item['duration'];
          int nextindex = cheekindex(i, length);
          // int nextindex2 = cheekindex2(i, length);
          // int nextindex3 = cheekindex3(i, length);
          // print(i);
          // print(nextindex);
          DateTime dtnext = DateTime.parse(result[nextindex]['start_time']);
          if (durationController.durationx.value.toInt() != 3) {
            if (DateTime(dt.year, dt.month, dt.day, dt.hour + 3) ==
                DateTime(dtnext.year, dtnext.month, dtnext.day, dtnext.hour)) {
              appointment.add(Appointment(
                startTime: dt,
                endTime: dt.add(Duration(hours: 3)),
                color: Colors.red,
                startTimeZone: '',
                endTimeZone: '',
                notes: '',
                isAllDay: false,
                subject: "",
              ));
              // DateTime dtnext = DateTime.parse(result[nextindex]['start_time']);
              appointment.add(Appointment(
                startTime: dtnext,
                endTime: dtnext.add(Duration(hours: 3)),
                color: Colors.red,
                startTimeZone: '',
                endTimeZone: '',
                notes: '',
                isAllDay: false,
                subject: "",
              ));

              result[nextindex] = {
                "id": "999999",
                "start_time": "2077-10-03 14:00",
                "duration": "3"
              };
            } else {
              if (dt.hour == 8) {
                // dt = dt.add(Duration(hours: 1));
                appointment.add(Appointment(
                  startTime: dt,
                  endTime: dt.add(Duration(hours: 4)),
                  color: Colors.red,
                  startTimeZone: '',
                  endTimeZone: '',
                  notes: '',
                  isAllDay: false,
                  subject: "",
                ));
              } else if (dt.hour == 11) {
                dt = dt.subtract(Duration(hours: 1));
                appointment.add(Appointment(
                  startTime: dt,
                  endTime: dt.add(Duration(hours: 4)),
                  color: Colors.red,
                  startTimeZone: '',
                  endTimeZone: '',
                  notes: '',
                  isAllDay: false,
                  subject: "",
                ));
              } else {
                appointment.add(Appointment(
                  startTime: dt,
                  endTime: dt.add(Duration(hours: 3)),
                  color: Colors.red,
                  startTimeZone: '',
                  endTimeZone: '',
                  notes: '',
                  isAllDay: false,
                  subject: "",
                ));
              }
            }
          } else {
            appointment.add(Appointment(
              startTime: dt,
              endTime: dt.add(Duration(hours: 3)),
              color: Colors.red,
              startTimeZone: '',
              endTimeZone: '',
              notes: '',
              isAllDay: false,
              subject: "",
            ));
          }
        }
      }
      _events.notifyListeners(CalendarDataSourceAction.add, appointment);
      setState(() {
        print("zzz");
        EasyLoading.dismiss();
      });
    } catch (e) {
      print(e);
    }

    // EasyLoading.show(
    //   dismissOnTap: true,
    //   maskType: EasyLoadingMaskType.custom,
    // );
    // try {
    //   http.Response response = await http.get(Uri.parse(
    //       'http://www.bergischreinigung.de/ap.php?type=get-all-dates'));
    //   // print(response.body);
    //   var result = jsonDecode(response.body);
    //   if (result != null) {
    //     for (var item in result) {
    //       DateTime dt = DateTime.parse(item['start_time']);
    //       // final Random random = Random();
    //       appointment.add(Appointment(
    //   startTime: dt,
    //   endTime: dt.add(
    //       Duration(hours: durationController.durationx.value.toInt())),
    //   color: Colors.red,
    //   startTimeZone: '',
    //   endTimeZone: '',
    //   notes: '',
    //   isAllDay: false,
    //   subject: "",
    // ));
    //     }
    //   }
    //   _events.notifyListeners(CalendarDataSourceAction.add, appointment);
    //   setState(() {
    //     // print("zzz");
    //     EasyLoading.dismiss();
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  int cheekindex(int index, int length) {
    if (index + 1 < length) {
      return index + 1;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    final Widget _calendar = _getAppointmentEditorCalendar(
      calendarController,
      _events,
      _onCalendarTapped,
      _onViewChanged,
    );
    final double _screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButton: Visibility(
          visible:
              durationController.appointmentState.value == 1 ? true : false,
          child: Container(
            height: 50,
            width: 50,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EventCalendar()));
              },
              backgroundColor: mainColor,
              child: Icon(Icons.add),
              elevation: 0,
              tooltip: "Add Apointment",
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: calendarController.view == CalendarView.month &&
                model.isWebFullView &&
                _screenHeight < 800
            ? Scrollbar(
                isAlwaysShown: true,
                controller: controller,
                child: ListView(
                  controller: controller,
                  children: <Widget>[
                    Container(
                      color: model.cardThemeColor,
                      height: 600,
                      child: _calendar,
                    )
                  ],
                ))
            : Stack(
                children: [
                  Container(color: model.cardThemeColor, child: _calendar),
                ],
              ),
      ),
    );
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    if (_view == calendarController.view ||
        model.isWebFullView ||
        (_view != CalendarView.month &&
            calendarController.view != CalendarView.month)) {
      return;
    }

    SchedulerBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        _view = calendarController.view;
      });
    });
    // if (calendarController.view == CalendarView.month) {
    //   apontmentxx.viewNumber.value = 0;
    // } else {
    //   apontmentxx.viewNumber.value = 1;
    // }
  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    // print("ondog");
    navigteData = calendarTapDetails.date;
    apontmentxx.datex.value = navigteData;
  }

  addpoint() {
    // final List<Appointment> appointmentCollection = <Appointment>[];
    _subjectCollection = <String>[];
    _subjectCollection.add('General Meeting');
    _subjectCollection.add('Plan Execution');
    _subjectCollection.add('Project Plan');
    _subjectCollection.add('Consulting');
    _subjectCollection.add('Support');
    _subjectCollection.add('Development Meeting');
    _subjectCollection.add('Scrum');
    _subjectCollection.add('Project Completion');
    _subjectCollection.add('Release updates');
    _subjectCollection.add('Performance Check');

    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF12D9F3));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    _colorNames = <String>[];
    _colorNames.add('Cyan');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Light Green');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _timeZoneCollection = <String>[];
    _timeZoneCollection.add('Default Time');
    _timeZoneCollection.add('AUS Central Standard Time');
    _timeZoneCollection.add('AUS Eastern Standard Time');
    _timeZoneCollection.add('Afghanistan Standard Time');
    _timeZoneCollection.add('Alaskan Standard Time');
    _timeZoneCollection.add('Arab Standard Time');
    _timeZoneCollection.add('Arabian Standard Time');
    _timeZoneCollection.add('Arabic Standard Time');
    _timeZoneCollection.add('Argentina Standard Time');
    _timeZoneCollection.add('Atlantic Standard Time');
    _timeZoneCollection.add('Azerbaijan Standard Time');
    _timeZoneCollection.add('Azores Standard Time');
    _timeZoneCollection.add('Bahia Standard Time');
    _timeZoneCollection.add('Bangladesh Standard Time');
    _timeZoneCollection.add('Belarus Standard Time');
    _timeZoneCollection.add('Canada Central Standard Time');
    _timeZoneCollection.add('Cape Verde Standard Time');
    _timeZoneCollection.add('Caucasus Standard Time');
    _timeZoneCollection.add('Cen. Australia Standard Time');
  }

  SfCalendar _getAppointmentEditorCalendar(
      [CalendarController _calendarController,
      CalendarDataSource _calendarDataSource,
      dynamic calendarTapCallback,
      ViewChangedCallback viewChangedCallback,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
      showDatePickerButton: true,
      controller: _calendarController,
      showNavigationArrow: model.isWebFullView,
      allowedViews: _allowedViews,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      dataSource: _calendarDataSource,
      onTap: calendarTapCallback,
      onViewChanged: viewChangedCallback,
      cellBorderColor: mainColor,
      appointmentTimeTextFormat: 'HH:mm',
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(Duration(days: 60)),
      initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0),
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          appointmentDisplayCount: 4,
          showAgenda: true,
          agendaItemHeight: 70,
          monthCellStyle: MonthCellStyle(
            todayBackgroundColor: Color.fromARGB(255, 0, 222, 233),
          )),
      firstDayOfWeek: 1,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeInterval: Duration(hours: durationController.durationx.value),
        timeIntervalHeight: -1,
        timeFormat: 'k:mm',
        startHour: durationController.startWork.value.toDouble(),
        endHour: durationController.endWork.value.toDouble(),
      ),
      headerHeight: 75,
    );
  }
}

typedef _PickerChanged = void Function(
    _PickerChangedDetails pickerChangedDetails);

class _PickerChangedDetails {
  _PickerChangedDetails({this.index = -1, this.resourceId});

  final int index;

  final Object resourceId;
}

class _DataSource extends CalendarDataSource {
  _DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}

String _getAppointmentTimeText(Appointment selectedAppointment) {
  if (selectedAppointment.isAllDay) {
    if (isSameDate(
        selectedAppointment.startTime, selectedAppointment.endTime)) {
      return DateFormat('EEEE, MMM dd')
          .format(selectedAppointment.startTime)
          .toString();
    }
    return DateFormat('EEEE, MMM dd').format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat('EEEE, MMM dd')
            .format(selectedAppointment.endTime)
            .toString();
  } else if (selectedAppointment.startTime.day !=
          selectedAppointment.endTime.day ||
      selectedAppointment.startTime.month !=
          selectedAppointment.endTime.month ||
      selectedAppointment.startTime.year != selectedAppointment.endTime.year) {
    String endFormat = 'EEEE, ';
    if (selectedAppointment.startTime.month !=
        selectedAppointment.endTime.month) {
      endFormat += 'MMM';
    }

    endFormat += ' dd hh:mm a';
    return DateFormat('EEEE, MMM dd hh:mm a')
            .format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat(endFormat).format(selectedAppointment.endTime);
  } else {
    return DateFormat('EEEE, MMM dd hh:mm a')
            .format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat('hh:mm a').format(selectedAppointment.endTime);
  }
}

Widget displayAppointmentDetails(
    BuildContext context,
    CalendarElement targetElement,
    DateTime selectedDate,
    SampleModel model,
    Appointment selectedAppointment,
    List<Color> colorCollection,
    List<String> colorNames,
    CalendarDataSource events,
    List<String> timeZoneCollection) {
  final Color defaultColor =
      model.themeData != null && model.themeData.brightness == Brightness.dark
          ? Colors.white
          : Colors.black54;

  final Color defaultTextColor =
      model.themeData != null && model.themeData.brightness == Brightness.dark
          ? Colors.white
          : Colors.black87;

  final List<Appointment> appointmentCollection = <Appointment>[];

  return ListView(padding: const EdgeInsets.all(0.0), children: <Widget>[
    ListTile(
        leading: Icon(
          Icons.lens,
          color: selectedAppointment.color,
          size: 20,
        ),
        title: Text(
            selectedAppointment.subject.isNotEmpty
                ? selectedAppointment.subject
                : '(No Text)',
            style: TextStyle(
                fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w400)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            _getAppointmentTimeText(selectedAppointment),
            style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
                fontWeight: FontWeight.w400),
          ),
        )),
    if (selectedAppointment.resourceIds == null ||
        selectedAppointment.resourceIds.isEmpty)
      Container()
    else
      ListTile(
        leading: Icon(
          Icons.people,
          size: 20,
          color: defaultColor,
        ),
        title: Text(
            _getSelectedResourceText(
                selectedAppointment.resourceIds, events.resources),
            style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
                fontWeight: FontWeight.w400)),
      ),
    if (selectedAppointment.location == null ||
        selectedAppointment.location.isEmpty)
      Container()
    else
      ListTile(
        leading: Icon(
          Icons.location_on,
          size: 20,
          color: defaultColor,
        ),
        title: Text(selectedAppointment.location ?? '',
            style: TextStyle(
                fontSize: 15,
                color: defaultColor,
                fontWeight: FontWeight.w400)),
      )
  ]);
}

String _getSelectedResourceText(
    List<Object> resourceIds, List<CalendarResource> resourceCollection) {
  String resourceNames;
  for (int i = 0; i < resourceIds.length; i++) {
    final String name = resourceCollection
        .firstWhere(
            (CalendarResource resource) => resource.id == resourceIds[i])
        .displayName;
    resourceNames = resourceNames == null ? name : resourceNames + ', ' + name;
  }

  return resourceNames;
}

class _CalendarColorPicker extends StatefulWidget {
  const _CalendarColorPicker(this.colorCollection, this.selectedColorIndex,
      this.colorNames, this.model,
      {@required this.onChanged});

  final List<Color> colorCollection;

  final int selectedColorIndex;

  final List<String> colorNames;

  final SampleModel model;

  final _PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() => _CalendarColorPickerState();
}

class _CalendarColorPickerState extends State<_CalendarColorPicker> {
  int _selectedColorIndex = -1;

  @override
  void initState() {
    _selectedColorIndex = widget.selectedColorIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarColorPicker oldWidget) {
    _selectedColorIndex = widget.selectedColorIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: kIsWeb ? 500 : double.maxFinite,
          height: (widget.colorCollection.length * 50).toDouble(),
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: widget.colorCollection.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 50,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: Icon(
                        index == _selectedColorIndex
                            ? Icons.lens
                            : Icons.trip_origin,
                        color: widget.colorCollection[index]),
                    title: Text(widget.colorNames[index]),
                    onTap: () {
                      print("1234F");
                      setState(() {
                        _selectedColorIndex = index;
                        widget.onChanged(_PickerChangedDetails(index: index));
                      });

                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.pop(context);
                      });
                    },
                  ));
            },
          )),
    );
  }
}

class _ResourcePicker extends StatefulWidget {
  const _ResourcePicker(this.resourceCollection, this.model,
      {@required this.onChanged});

  final List<CalendarResource> resourceCollection;

  final _PickerChanged onChanged;

  final SampleModel model;

  @override
  State<StatefulWidget> createState() => _ResourcePickerState();
}

class _ResourcePickerState extends State<_ResourcePicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: kIsWeb ? 500 : double.maxFinite,
          height: (widget.resourceCollection.length * 50).toDouble(),
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: widget.resourceCollection.length,
            itemBuilder: (BuildContext context, int index) {
              final CalendarResource resource =
                  widget.resourceCollection[index];
              return Container(
                  height: 50,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: CircleAvatar(
                      backgroundColor: widget.model.backgroundColor,
                      backgroundImage: resource.image,
                      child: resource.image == null
                          ? Text(resource.displayName[0])
                          : null,
                    ),
                    title: Text(resource.displayName),
                    onTap: () {
                      print("1234E");
                      setState(() {
                        widget.onChanged(
                            _PickerChangedDetails(resourceId: resource.id));
                      });

                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.pop(context);
                      });
                    },
                  ));
            },
          )),
    );
  }
}

class _CalendarTimeZonePicker extends StatefulWidget {
  const _CalendarTimeZonePicker(this.backgroundColor, this.timeZoneCollection,
      this.selectedTimeZoneIndex, this.model,
      {@required this.onChanged});

  final Color backgroundColor;

  final List<String> timeZoneCollection;

  final int selectedTimeZoneIndex;

  final SampleModel model;

  final _PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() {
    return _CalendarTimeZonePickerState();
  }
}

class _CalendarTimeZonePickerState extends State<_CalendarTimeZonePicker> {
  int _selectedTimeZoneIndex = -1;

  @override
  void initState() {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarTimeZonePicker oldWidget) {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: kIsWeb ? 500 : double.maxFinite,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: widget.timeZoneCollection.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 50,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: Icon(
                      index == _selectedTimeZoneIndex
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: widget.backgroundColor,
                    ),
                    title: Text(widget.timeZoneCollection[index]),
                    onTap: () {
                      print("1234c");
                      setState(() {
                        _selectedTimeZoneIndex = index;
                        widget.onChanged(_PickerChangedDetails(index: index));
                      });

                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.pop(context);
                      });
                    },
                  ));
            },
          )),
    );
  }
}
