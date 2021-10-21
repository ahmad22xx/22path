import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class FreeX extends StatefulWidget {
  @override
  State<FreeX> createState() => _ScheduleExample();
}

class _ScheduleExample extends State<FreeX> {
  _MeetingDataSource _events;
  List<_Meeting> _appointments = <_Meeting>[];
  final List<DateTime> _freeTime = <DateTime>[];
  final double _startHour = 0;
  final double _endHour = 17;
  final Duration _timeInterval = const Duration(minutes: 180);
  final CalendarController _controller = CalendarController();

  @override
  void initState() {
    _appointments = _addAppointment();
    _events = _MeetingDataSource(_appointments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          TextButton(
            child: const Text('Get free slots'),
            onPressed: _showDialog,
          ),
          Expanded(
            child: SfCalendar(
              view: CalendarView.day,
              controller: _controller,
              dataSource: _events,
              timeSlotViewSettings: TimeSlotViewSettings(
                  timeFormat: 'k:mm',
                  startHour: _startHour,
                  endHour: _endHour,
                  timeInterval: _timeInterval),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> _showDialog() async {
    _freeTime.clear();
    final List<Appointment> visibleAppointments =
        _events.getVisibleAppointments(_controller.displayDate, '');
    final List<int> eventsSlotHour = <int>[];
    for (int i = 0; i < visibleAppointments.length; i++) {
      final Appointment app = visibleAppointments[i];
      final int endHour = (isSameDate(app.startTime, app.endTime) ||
              isSameDate(app.endTime, _controller.displayDate))
          ? app.endTime.hour
          : _endHour.toInt();
      final int startHour = (isSameDate(app.startTime, app.endTime) ||
              isSameDate(app.startTime, _controller.displayDate))
          ? app.startTime.hour
          : _startHour.toInt();
      for (int i = startHour; i <= endHour; i++) {
        eventsSlotHour.add(i);
      }
    }
    for (int i = _startHour.toInt(); i <= _endHour.toInt(); i++) {
      if (!eventsSlotHour.contains(i)) {
        final DateTime freeTime = DateTime(_controller.displayDate.year,
            _controller.displayDate.month, _controller.displayDate.day, i);
        _freeTime.add(freeTime);
      }
    }

    await showDialog<Widget>(
      builder: (BuildContext context) => AlertDialog(
        title: Container(
          child: Text('Visible dates contains ' +
              _freeTime.length.toString() +
              'slots'),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: 200,
          width: 200,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _freeTime.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    color: Colors.greenAccent,
                    child: Text(_freeTime[index].toString()));
              }),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      context: context,
    );
  }

  List<_Meeting> _addAppointment() {
    // _appointments.add(_Meeting('Meeting', DateTime(2021, 10, 16, 9, 0, 0),
    //     DateTime(2021, 10, 12, 10, 0, 0), Colors.greenAccent, false));
    // _appointments.add(_Meeting('Span', DateTime(2021, 10, 14, 16, 0, 0),
    //     DateTime(2021, 10, 15, 09, 0, 0), Colors.red, false));
    _appointments.add(_Meeting('Discussion', DateTime(2021, 10, 17, 0, 0, 0),
        DateTime(2021, 10, 17, 10, 0, 0), Colors.greenAccent, false));
    _appointments.add(_Meeting('Planning', DateTime(2021, 10, 19, 12, 0, 0),
        DateTime(2021, 10, 16, 23, 0, 0), Colors.greenAccent, false));

    // meetingCollection?.add(Meeting(
    //     "planning",
    //     DateTime(2021,10,13,9,0,0),
    //     DateTime(2021,10,13,10,0,0),
    //     Colors.greenAccent,
    //     false));
    return _appointments;
  }

  bool isSameDate(dynamic date1, dynamic date2) {
    if (date2 == date1) {
      return true;
    }

    if (date1 == null || date2 == null) {
      return false;
    }

    return date1.month == date2.month &&
        date1.year == date2.year &&
        date1.day == date2.day;
  }
}

class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(List<_Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from as DateTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to as DateTime;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay as bool;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName as String;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background as Color;
  }
}

class _Meeting {
  _Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
