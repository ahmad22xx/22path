import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/sample_view.dart';

class TimelineViewsCalendar extends SampleView {
  const TimelineViewsCalendar(Key key) : super(key: key);

  @override
  _TimelineViewsCalendarState createState() => _TimelineViewsCalendarState();
}

class _TimelineViewsCalendarState extends SampleViewState {
  _TimelineViewsCalendarState();

  final List<String> _subjectCollection = <String>[];
  final List<Color> _colorCollection = <Color>[];
  final CalendarController _calendarController = CalendarController();

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];

  List<DateTime> _blackoutDates = <DateTime>[];
  _MeetingDataSource _events;

  @override
  void initState() {
    _calendarController.view = CalendarView.timelineMonth;
    addAppointmentDetails();
    _events = _MeetingDataSource(<_Meeting>[]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: Container(
              color: model.cardThemeColor,
              child: _getTimelineViewsCalendar(
                  _calendarController, _events, _onViewChanged)),
        )
      ]),
    );
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    final List<_Meeting> appointment = <_Meeting>[];
    _events.appointments.clear();
    final Random random = Random();
    final List<DateTime> blockedDates = <DateTime>[];
    if (_calendarController.view == CalendarView.timelineMonth) {
      for (int i = 0; i < 5; i++) {
        blockedDates.add(visibleDatesChangedDetails.visibleDates[
            random.nextInt(visibleDatesChangedDetails.visibleDates.length)]);
      }
    }

    SchedulerBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        if (_calendarController.view == CalendarView.timelineMonth) {
          _blackoutDates = blockedDates;
        } else {
          _blackoutDates.clear();
        }
      });
    });

    for (int i = 0; i < visibleDatesChangedDetails.visibleDates.length; i++) {
      final DateTime date = visibleDatesChangedDetails.visibleDates[i];
      if (blockedDates != null &&
          blockedDates.isNotEmpty &&
          blockedDates.contains(date)) {
        continue;
      }
      final int count =
          model.isWebFullView ? 1 + random.nextInt(2) : 1 + random.nextInt(3);
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
            date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
        appointment.add(_Meeting(
            _subjectCollection[random.nextInt(7)],
            '',
            '',
            null,
            startDate,
            startDate.add(Duration(hours: random.nextInt(3))),
            _colorCollection[random.nextInt(9)],
            false,
            '',
            '',
            i == 0 ? 'FREQ=DAILY;INTERVAL=1' : ''));
      }
    }

    for (int i = 0; i < appointment.length; i++) {
      _events.appointments.add(appointment[i]);
    }

    _events.notifyListeners(CalendarDataSourceAction.reset, appointment);
  }

  void addAppointmentDetails() {
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

    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  SfCalendar _getTimelineViewsCalendar(
      [CalendarController _calendarController,
      CalendarDataSource _calendarDataSource,
      ViewChangedCallback viewChangedCallback]) {
    return SfCalendar(
        controller: _calendarController,
        dataSource: _calendarDataSource,
        allowedViews: _allowedViews,
        showNavigationArrow: model.isWebFullView,
        showDatePickerButton: true,
        onViewChanged: viewChangedCallback,
        blackoutDates: _blackoutDates,
        blackoutDatesTextStyle: TextStyle(
            decoration: model.isWebFullView ? null : TextDecoration.lineThrough,
            color: Colors.red),
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)));
  }
}

class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(this.source);

  List<_Meeting> source;

  @override
  List<_Meeting> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  String getStartTimeZone(int index) {
    return source[index].startTimeZone;
  }

  @override
  String getEndTimeZone(int index) {
    return source[index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  String getRecurrenceRule(int index) {
    return source[index].recurrenceRule;
  }
}

class _Meeting {
  _Meeting(
      this.eventName,
      this.organizer,
      this.contactID,
      this.capacity,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.startTimeZone,
      this.endTimeZone,
      this.recurrenceRule);

  String eventName;
  String organizer;
  String contactID;
  int capacity;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String startTimeZone;
  String endTimeZone;
  String recurrenceRule;
}
