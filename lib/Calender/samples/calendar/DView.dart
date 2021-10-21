library event_calendar;

import 'dart:async';
import 'dart:convert';
import 'package:cleanx/Home.dart';
import 'package:cleanx/controller.dart/appointmentC.dart';
import 'package:cleanx/controller.dart/stateController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

part 'appointment-editor.dart';

//ignore: must_be_immutable
class EventCalendar extends StatefulWidget {
  const EventCalendar({Key key}) : super(key: key);

  @override
  EventCalendarState createState() => EventCalendarState();
}

final apontmentxx = Get.put(ApointmentController());
final durationController = Get.put(StateController());
List<Meeting> meetingCollection = <Meeting>[];
final List<TimeRegion> regions = <TimeRegion>[];
List<Color> _colorCollection;
List<String> _colorNames;
int _selectedColorIndex = 0;
int _selectedTimeZoneIndex = 0;
List<String> _timeZoneCollection;
DataSource events;
Meeting _selectedAppointment;
DateTime _startDate;
// ignore: unused_element
TimeOfDay _startTime;
DateTime _endDate;
// ignore: unused_element
TimeOfDay _endTime;
bool _isAllDay;
String _subject = '';
String _notes = '';

class EventCalendarState extends State<EventCalendar> {
  EventCalendarState();
  CalendarController calenderx = CalendarController();
  CalendarView _calendarView;
  List<String> eventNameCollection;
  List<Meeting> appointments;

  @override
  void initState() {
    _calendarView = CalendarView.day;
    getTravleName();
    getMeetingDetails();
    getTimeRegions();
    appointments = meetingCollection;
    events = DataSource(appointments);
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';
    super.initState();
  }

  @override
  void dispose() {
    calenderx.dispose();
    meetingCollection.clear();
    super.dispose();
  }

  getTimeRegions() {
    regions.add(TimeRegion(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(days: 60)),
      recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
      color: Color(0xFF00F715),
      enablePointerInteraction: true,
    ));
  }

  @override
  Widget build([BuildContext context]) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: getEventCalendar(_calendarView, events, onCalendarTapped)));
  }

  SfCalendar getEventCalendar(
      [CalendarView _calendarView,
      CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback]) {
    return SfCalendar(
      cellBorderColor: Colors.grey[850],
      specialRegions: regions,
      controller: calenderx,
      view: CalendarView.day,
      dataSource: _calendarDataSource,
      onTap: calendarTapCallback,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      appointmentTimeTextFormat: 'HH:mm',
      showDatePickerButton: true,
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(Duration(days: 60)),
      initialDisplayDate: apontmentxx.datex.value,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeInterval: Duration(hours: durationController.durationx.value),
        timeIntervalHeight: -1,

        // allDayPanelColor: Colors.red,
        timeFormat: 'k:mm',
        startHour: durationController.startWork.value.toDouble(),
        endHour: durationController.endWork.value.toDouble(),
      ),
      headerHeight: 75,
    );
  }

  void onCalendarViewChange(String value) {
    if (value == 'Day') {
      _calendarView = CalendarView.day;
    } else if (value == 'Week') {
      _calendarView = CalendarView.week;
    } else if (value == 'Work week') {
      _calendarView = CalendarView.workWeek;
    } else if (value == 'Month') {
      _calendarView = CalendarView.month;
    } else if (value == 'Timeline day') {
      _calendarView = CalendarView.timelineDay;
    } else if (value == 'Timeline week') {
      _calendarView = CalendarView.timelineWeek;
    } else if (value == 'Timeline work week') {
      _calendarView = CalendarView.timelineWorkWeek;
    }

    setState(() {});
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      if (_calendarView == CalendarView.month) {
        _calendarView = CalendarView.day;
      } else {
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments.length == 1) {
          final Meeting meetingDetails = calendarTapDetails.appointments[0];
          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _isAllDay = meetingDetails.isAllDay;
          _selectedColorIndex =
              _colorCollection.indexOf(meetingDetails.background);
          _selectedTimeZoneIndex = meetingDetails.startTimeZone == ''
              ? 0
              : _timeZoneCollection.indexOf(meetingDetails.startTimeZone);
          _subject = meetingDetails.eventName == '(No title)'
              ? ''
              : meetingDetails.eventName;
          _notes = meetingDetails.description;
          _selectedAppointment = meetingDetails;
        } else {
          final DateTime date = calendarTapDetails.date;
          _startDate = date;
          _endDate =
              date.add(Duration(hours: durationController.durationx.value));
        }
        _startTime =
            TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AppointmentEditor()),
        );
      }
    });
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
          String duration = result[i]['duration'];
          // int duration = item['duration'];
          int nextindex = cheekindex(i, length);
          // int nextindex2 = cheekindex2(i, length);
          // int nextindex3 = cheekindex3(i, length);
          // print(i);
          // print(nextindex);
          DateTime dtnext = DateTime.parse(result[nextindex]['start_time']);
          if (durationController.durationx.value.toInt() != 3 &&
              duration == '3') {
            if (DateTime(dt.year, dt.month, dt.day, dt.hour + 3) ==
                DateTime(dtnext.year, dtnext.month, dtnext.day, dtnext.hour)) {
              meetingCollection.add(Meeting(
                from: dt,
                to: dt.add(Duration(hours: 3)),
                background: Color(0xE8F80F0F),
                startTimeZone: '',
                endTimeZone: '',
                description: '',
                isAllDay: false,
                eventName: "",
              ));
              // DateTime dtnext = DateTime.parse(result[nextindex]['start_time']);
              meetingCollection.add(Meeting(
                from: dtnext,
                to: dtnext.add(Duration(hours: 3)),
                background: Color(0xE8F80F0F),
                startTimeZone: '',
                endTimeZone: '',
                description: '',
                isAllDay: false,
                eventName: "",
              ));

              result[nextindex] = {
                "id": "999999",
                "start_time": "2077-10-03 14:00",
                "duration": "3"
              };
            } else {
              if (dt.hour == 8) {
                // dt = dt.add(Duration(hours: 1));
                meetingCollection.add(Meeting(
                  from: dt,
                  to: dt.add(Duration(hours: 4)),
                  background: Color(0xE8F80F0F),
                  startTimeZone: '',
                  endTimeZone: '',
                  description: '',
                  isAllDay: false,
                  eventName: "",
                ));
              } else if (dt.hour == 11) {
                DateTime dtR = dt.subtract(Duration(minutes: 55));
                regions.add(TimeRegion(
                  startTime: dtR,
                  endTime: dtR.add(Duration(hours: 1)),
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
                  color: Color(0xE8F80F0F),
                  enablePointerInteraction: false,
                ));
                meetingCollection.add(Meeting(
                  from: dt,
                  to: dt.add(Duration(hours: 3)),
                  background: Color(0xE8F80F0F),
                  startTimeZone: '',
                  endTimeZone: '',
                  description: '',
                  isAllDay: false,
                  eventName: "",
                ));
              } else {
                meetingCollection.add(Meeting(
                  from: dt,
                  to: dt.add(Duration(hours: 3)),
                  background: Color(0xE8F80F0F),
                  startTimeZone: '',
                  endTimeZone: '',
                  description: '',
                  isAllDay: false,
                  eventName: "",
                ));
              }
            }
          } else {
            meetingCollection.add(Meeting(
              from: dt,
              to: dt.add(Duration(hours: int.parse(duration))),
              background: Color(0xE8F80F0F),
              startTimeZone: '',
              endTimeZone: '',
              description: '',
              isAllDay: false,
              eventName: "",
            ));
          }
          // if (durationController.durationx.value.toInt() == 3) {
          //   if (DateTime(dt.year, dt.month, dt.day, dt.hour).difference(
          //           DateTime(dtnext.year, dtnext.month, dtnext.day)) ==
          //       3) {
          //     regions.add(TimeRegion(
          //       startTime: DateTime(dt.year, dt.month, dt.day, dt.hour)
          //           .add(Duration(hours: 2)),
          //       endTime: DateTime(dt.year, dt.month, dt.day, dt.hour)
          //           .add(Duration(hours: 3)),
          //       recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
          //       color: Color(0xFF00F715),
          //       enablePointerInteraction: true,
          //     ));
          //   }
          // }
          // if (durationController.durationx.value.toInt() == 3) {
          //   DateTime dtnext = DateTime.parse(result[nextindex]['start_time']);
          //   DateTime dtnext2 = DateTime.parse(result[nextindex2]['start_time']);
          //   DateTime dtnext3 = DateTime.parse(result[nextindex3]['start_time']);
          //   if (DateTime(dt.year, dt.month, dt.day, dt.hour + 2) ==
          //           DateTime(dtnext.year, dtnext.month, dtnext.day,
          //               dtnext.hour) &&
          //       DateTime(dt.year, dt.month, dt.day, dt.hour + 4) ==
          //           DateTime(dtnext2.year, dtnext2.month, dtnext2.day,
          //               dtnext2.hour) &&
          //       DateTime(dt.year, dt.month, dt.day, dt.hour + 6) ==
          //           DateTime(dtnext3.year, dtnext3.month, dtnext3.day,
          //               dtnext3.hour)) {

          //               }
          // }
          // after 3  && befor 2
          // if (durationController.durationx.value.toInt() == 3) {
          //   DateTime dtnext = DateTime.parse(result[nextindex]['start_time']);

          //   if (DateTime(dt.year, dt.month, dt.day, dt.hour + 3) ==
          //       DateTime(dtnext.year, dtnext.month, dtnext.day, dtnext.hour)) {
          //     meetingCollection.add(Meeting(
          //       from: dt,
          //       to: dt.add(Duration(hours: 3)),
          //       background: Color(0xE8F80F0F),
          //       startTimeZone: '',
          //       endTimeZone: '',
          //       description: '',
          //       isAllDay: false,
          //       eventName: "",
          //     ));
          //     DateTime dtnext = DateTime.parse(result[nextindex]['start_time']);
          //     meetingCollection.add(Meeting(
          //       from: dtnext,
          //       to: dtnext.add(Duration(hours: 3)),
          //       background: Color(0xE8F80F0F),
          //       startTimeZone: '',
          //       endTimeZone: '',
          //       description: '',
          //       isAllDay: false,
          //       eventName: "",
          //     ));

          //     result[nextindex] = {
          //       "id": "999999",
          //       "start_time": "2077-10-03 14:00",
          //       "duration": "3"
          //     };
          //   }
          // }
        }
      }
      events.notifyListeners(CalendarDataSourceAction.add, meetingCollection);
      setState(() {
        print("zzz");
        EasyLoading.dismiss();
      });
    } catch (e) {
      print(e);
    }
  }

  int cheekindex(int index, int length) {
    if (index + 1 < length) {
      return index + 1;
    }
    return index;
  }

  int cheekindex2(int index, int length) {
    if (index + 2 < length) {
      return index + 2;
    }
    return index;
  }

  int cheekindex3(int index, int length) {
    if (index + 3 < length) {
      return index + 3;
    }
    return index;
  }

  void getMeetingDetails() {
    eventNameCollection = <String>[];
    eventNameCollection.add('General Meeting');
    eventNameCollection.add('Plan Execution');
    eventNameCollection.add('Project Plan');
    eventNameCollection.add('Consulting');
    // eventNameCollection.add('Support');
    // eventNameCollection.add('Development Meeting');
    // eventNameCollection.add('Scrum');
    // eventNameCollection.add('Project Completion');
    // eventNameCollection.add('Release updates');
    // eventNameCollection.add('Performance Check');

    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF00F715));
    _colorCollection.add(const Color(0xE8F80F0F));
    // _colorCollection.add(const Color(0xFFD20100));
    // _colorCollection.add(const Color(0xFFFC571D));
    // _colorCollection.add(const Color(0xFF85461E));
    // _colorCollection.add(const Color(0xFFFF00FF));
    // _colorCollection.add(const Color(0xFF3D4FB5));
    // _colorCollection.add(const Color(0xFFE47C73));
    // _colorCollection.add(const Color(0xFF636363));

    _colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Red');
    // _colorNames.add('Red');
    // _colorNames.add('Orange');
    // _colorNames.add('Caramel');
    // _colorNames.add('Magenta');
    // _colorNames.add('Blue');
    // _colorNames.add('Peach');
    // _colorNames.add('Gray');

    _timeZoneCollection = <String>[];
    _timeZoneCollection.add('Default Time');
    _timeZoneCollection.add('AUS Central Standard Time');
    _timeZoneCollection.add('AUS Eastern Standard Time');
    _timeZoneCollection.add('Afghanistan Standard Time');
    _timeZoneCollection.add('Alaskan Standard Time');
    // _timeZoneCollection.add('Arab Standard Time');
    // _timeZoneCollection.add('Arabian Standard Time');
    // _timeZoneCollection.add('Arabic Standard Time');
    // _timeZoneCollection.add('Argentina Standard Time');
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  bool isAllDay(int index) => appointments[index].isAllDay;

  @override
  String getSubject(int index) => appointments[index].eventName;

  @override
  String getStartTimeZone(int index) => appointments[index].startTimeZone;

  @override
  String getNotes(int index) => appointments[index].description;

  @override
  String getEndTimeZone(int index) => appointments[index].endTimeZone;

  @override
  Color getColor(int index) => appointments[index].background;

  @override
  DateTime getStartTime(int index) => appointments[index].from;

  @override
  DateTime getEndTime(int index) => appointments[index].to;
}

class Meeting {
  Meeting(
      {@required this.from,
      @required this.to,
      this.background = Colors.green,
      this.isAllDay = false,
      this.eventName = '',
      this.startTimeZone = '',
      this.endTimeZone = '',
      this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}
