import 'dart:async';
import 'dart:convert';

import 'package:cleanx/Home.dart';
import 'package:cleanx/const/colors.dart';
import 'package:cleanx/controller.dart/appointmentC.dart';
import 'package:cleanx/controller.dart/stateController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:http/http.dart' as http;
import '../../model/model.dart';
import '../../model/sample_view.dart';

class CalendarAppointmentDay extends SampleView {
  @override
  _CalendarAppointmentDayState createState() => _CalendarAppointmentDayState();
}

class _CalendarAppointmentDayState extends SampleViewState {
  _CalendarAppointmentDayState();

  final apontmentxx = Get.put(ApointmentController());
  final durationController = Get.put(StateController());
  final List<Meeting> appointment = <Meeting>[];
  List<String> subjectCollection;
  List<Meeting> _appointments;
  bool _isMobile;
  List<Color> _colorCollection;
  List<String> _colorNames;
  int selectedColorIndex = 0;
  List<String> _timeZoneCollection;
  _DataSource _events;
  Meeting _selectedAppointment;
  bool isAllDay = false;
  String subject = '';
  final ScrollController controller = ScrollController();
  final CalendarController calendarController = CalendarController();
  CalendarView _view = CalendarView.month;
  @override
  void initState() {
    addpoint();
    getTravleName();
    _isMobile = false;
    _events = _DataSource(_appointments);
    _selectedAppointment = null;
    selectedColorIndex = 0;
    subject = '';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _isMobile = MediaQuery.of(context).size.width < 767;
    super.didChangeDependencies();
  }

  Future getTravleName() async {
    EasyLoading.show(
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.custom,
    );
    try {
      http.Response response = await http.get(Uri.parse(
          'http://www.bergischreinigung.de/ap.php?type=get-all-dates'));
      print(response.body);
      var result = jsonDecode(response.body);
      if (result != null) {
        for (var item in result) {
          DateTime dt = DateTime.parse(item['start_time']);

          appointment.add(Meeting(
            from: dt,
            to: dt.add(Duration(hours: durationController.durationx.value)),
            background: Color(0xFFFF0000),
            startTimeZone: '',
            endTimeZone: '',
            description: '',
            isAllDay: false,
            eventName: "",
          ));
        }
      }
      _events.notifyListeners(CalendarDataSourceAction.add, appointment);
      setState(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      print(e);
    }
  }

  int changeDuration(DateTime dt) {
    if (dt.hour == 11 || dt.hour == 14) {
      int dts = dt.hour - 1;
      return dts;
    }
    return dt.hour;
  }

  @override
  Widget build(BuildContext context) {
    final Widget _calendar = _getAppointmentEditorCalendar(
      calendarController,
      _events,
      _onCalendarTapped,
      _onViewChanged,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(color: model.cardThemeColor, child: _calendar),
          Container(
            margin: EdgeInsets.only(top: 70, right: 0),
            height: 70,
            width: double.infinity,
            color: Colors.transparent,
          ),
        ],
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
  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarController.view == CalendarView.day) {
      if (calendarTapDetails.targetElement == CalendarElement.header ||
          calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
        return;
      }

      _selectedAppointment = null;

      if (model.isWebFullView &&
          calendarController.view == CalendarView.month) {
        calendarController.view = CalendarView.day;
      } else {
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.targetElement == CalendarElement.appointment) {
          final dynamic appointment = calendarTapDetails.appointments[0];
          if (appointment is Meeting) {
            _selectedAppointment = appointment;
          }
        }

        final DateTime selectedDate = calendarTapDetails.date;
        final CalendarElement targetElement = calendarTapDetails.targetElement;

        if (model.isWebFullView && _isMobile) {
          final bool _isAppointmentTapped =
              calendarTapDetails.targetElement == CalendarElement.appointment;
          showDialog<Widget>(
              context: context,
              builder: (BuildContext context) {
                final List<Meeting> appointment = <Meeting>[];
                Meeting newAppointment;

                if (_selectedAppointment == null) {
                  isAllDay = calendarTapDetails.targetElement ==
                      CalendarElement.allDayPanel;
                  selectedColorIndex = 0;
                  subject = '';
                  // final DateTime date = calendarTapDetails.date;

                  appointment.add(newAppointment);

                  _events.appointments.add(appointment[0]);

                  SchedulerBinding.instance
                      ?.addPostFrameCallback((Duration duration) {
                    _events.notifyListeners(
                        CalendarDataSourceAction.add, appointment);
                  });

                  _selectedAppointment = newAppointment;
                }

                return WillPopScope(
                  onWillPop: () async {
                    if (newAppointment != null) {
                      _events.appointments.removeAt(
                          _events.appointments.indexOf(newAppointment));
                      _events.notifyListeners(CalendarDataSourceAction.remove,
                          <Meeting>[newAppointment]);
                    }
                    return true;
                  },
                  child: Center(
                      child: Container(
                          alignment: Alignment.center,
                          width: _isAppointmentTapped ? 400 : 500,
                          height: 200,
                          child: Card(
                            margin: const EdgeInsets.all(0.0),
                            color: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            child: PopUpAppointmentEditor(
                                model,
                                newAppointment,
                                appointment,
                                _events,
                                _colorCollection,
                                _colorNames,
                                _selectedAppointment,
                                _timeZoneCollection),
                          ))),
                );
              });
        } else {
          Navigator.push<Widget>(
            context,
            MaterialPageRoute<Widget>(
                builder: (BuildContext context) => AppointmentEditor(
                    model,
                    _selectedAppointment,
                    targetElement,
                    selectedDate,
                    _colorCollection,
                    _colorNames,
                    _events,
                    _timeZoneCollection)),
          );
        }
      }
    } else {
      print("else");
    }
  }

  void addpoint() {
    subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Plan Execution');
    subjectCollection.add('Project Plan');
    subjectCollection.add('Consulting');
    subjectCollection.add('Support');

    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF06FF1B));

    _colorCollection.add(const Color(0xFFFF0000));

    _colorNames = <String>[];
    _colorNames.add('Red');
    _colorNames.add('Green');
    _colorNames.add('Red');

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
  }

  SfCalendar _getAppointmentEditorCalendar(
      [CalendarController _calendarController,
      CalendarDataSource _calendarDataSource,
      dynamic calendarTapCallback,
      ViewChangedCallback viewChangedCallback,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
      appointmentTimeTextFormat: 'HH:mm',
      controller: _calendarController,
      showDatePickerButton: true,
      showNavigationArrow: model.isWebFullView,
      view: CalendarView.day,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      dataSource: _calendarDataSource,
      onTap: calendarTapCallback,
      onViewChanged: viewChangedCallback,
      cellBorderColor: mainColor,
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(Duration(days: 60)),
      initialDisplayDate: apontmentxx.datex.value,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeInterval: Duration(hours: durationController.durationx.value),
        timeIntervalHeight: -1,
        timeFormat: 'k:mm',
        startHour: 8,
        endHour: 16,
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

class _DataSource extends CalendarDataSource {
  _DataSource(this.source) {
    appointments = source;
  }
  List<Meeting> source;

  @override
  List<dynamic> get appointments => source;
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

String getAppointmentTimeText(Appointment selectedAppointment) {
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

String getSelectedResourceText(
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
  int selectedColorIndex = -1;

  @override
  void initState() {
    selectedColorIndex = widget.selectedColorIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarColorPicker oldWidget) {
    selectedColorIndex = widget.selectedColorIndex;
    super.didUpdateWidget(oldWidget);
  }

  final apontmentxColor = Get.put(ApointmentController());
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
                        index == selectedColorIndex
                            ? Icons.lens
                            : Icons.trip_origin,
                        color: widget.colorCollection[index]),
                    title: Text(widget.colorNames[index]),
                    onTap: () {
                      apontmentxColor.colorsx.value =
                          widget.colorCollection[index].toString();
                      print(widget.colorCollection[index].toString());

                      setState(() {
                        selectedColorIndex = index;
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
  int selectedTimeZoneIndex = -1;

  @override
  void initState() {
    selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarTimeZonePicker oldWidget) {
    selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
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
                      index == selectedTimeZoneIndex
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: widget.backgroundColor,
                    ),
                    title: Text(widget.timeZoneCollection[index]),
                    onTap: () {
                      setState(() {
                        selectedTimeZoneIndex = index;
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

class PopUpAppointmentEditor extends StatefulWidget {
  const PopUpAppointmentEditor(
      this.model,
      this.newAppointment,
      this.appointment,
      this.events,
      this.colorCollection,
      this.colorNames,
      this.selectedAppointment,
      this.timeZoneCollection);

  final SampleModel model;

  final Meeting newAppointment;

  final List<Meeting> appointment;

  final CalendarDataSource events;

  final List<Color> colorCollection;

  final List<String> colorNames;

  final Meeting selectedAppointment;

  final List<String> timeZoneCollection;

  @override
  _PopUpAppointmentEditorState createState() => _PopUpAppointmentEditorState();
}

class _PopUpAppointmentEditorState extends State<PopUpAppointmentEditor> {
  int selectedColorIndex = 0;
  int selectedTimeZoneIndex = 0;
  DateTime _startDate;
  DateTime _endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool isAllDay = false;
  String subject = '';
  String notes;
  String location;
  List<Object> _resourceIds;
  List<CalendarResource> _selectedResources = <CalendarResource>[];
  List<CalendarResource> unSelectedResources = <CalendarResource>[];

  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(PopUpAppointmentEditor oldWidget) {
    _updateAppointmentProperties();
    super.didUpdateWidget(oldWidget);
  }

  void _updateAppointmentProperties() {
    _startDate = widget.selectedAppointment.from;
    _endDate = widget.selectedAppointment.to;
    isAllDay = widget.selectedAppointment.isAllDay;
    selectedColorIndex =
        widget.colorCollection.indexOf(widget.selectedAppointment.background);
    selectedTimeZoneIndex = widget.selectedAppointment.startTimeZone == null ||
            widget.selectedAppointment.startTimeZone == ''
        ? 0
        : widget.timeZoneCollection
            .indexOf(widget.selectedAppointment.startTimeZone);
    subject = widget.selectedAppointment.eventName == '(No title)'
        ? ''
        : widget.selectedAppointment.eventName;
    notes = widget.selectedAppointment.description;

    selectedColorIndex = selectedColorIndex == -1 ? 0 : selectedColorIndex;
    selectedTimeZoneIndex =
        selectedTimeZoneIndex == -1 ? 0 : selectedTimeZoneIndex;

    startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _selectedResources =
        _getSelectedResources(_resourceIds, widget.events.resources);
    unSelectedResources =
        _getUnSelectedResources(_selectedResources, widget.events.resources);
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = Colors.black54;

    final Color defaultTextColor = Colors.black87;

    return ListView(padding: const EdgeInsets.all(0.0), children: <Widget>[
      Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
                width: 30,
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.location_on,
                  color: defaultColor,
                  size: 20,
                )),
            title: TextField(
              cursorColor: widget.model.backgroundColor,
              controller: TextEditingController(text: location),
              onChanged: (String value) {
                location = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
              ),
              decoration: const InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: 'Add location',
              ),
            ),
          )),
      Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,
          child: ListTile(
            leading: Container(
                width: 30,
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.subject,
                  size: 20,
                  color: Colors.red,
                )),
            title: TextField(
              controller: TextEditingController(text: notes),
              onChanged: (String value) {
                notes = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: widget.model.isWebFullView ? 1 : null,
              style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
              ),
              decoration: const InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: 'Add description',
              ),
            ),
          )),
      if (widget.events.resources == null || widget.events.resources.isEmpty)
        Container()
      else
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: 50,
            child: ListTile(
              leading: Container(
                  width: 30,
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.lens,
                      size: 20,
                      color: widget.colorCollection[selectedColorIndex])),
              title: RawMaterialButton(
                padding: const EdgeInsets.only(left: 5),
                onPressed: () {
                  showDialog<Widget>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return _CalendarColorPicker(
                        widget.colorCollection,
                        selectedColorIndex,
                        widget.colorNames,
                        widget.model,
                        onChanged: (_PickerChangedDetails details) {
                          selectedColorIndex = details.index;
                        },
                      );
                    },
                  ).then((dynamic value) => setState(() {}));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.colorNames[selectedColorIndex],
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: defaultTextColor),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            )),
    ]);
  }

  Widget getResourceEditor(TextStyle hintTextStyle) {
    if (_selectedResources == null || _selectedResources.isEmpty) {
      return Text('Add people', style: hintTextStyle);
    }

    final List<Widget> chipWidgets = <Widget>[];
    for (int i = 0; i < _selectedResources.length; i++) {
      final CalendarResource selectedResource = _selectedResources[i];
      chipWidgets.add(Chip(
        padding: const EdgeInsets.only(left: 0),
        avatar: CircleAvatar(
          backgroundColor: widget.model.backgroundColor,
          backgroundImage: selectedResource.image,
          child: selectedResource.image == null
              ? Text(selectedResource.displayName[0])
              : null,
        ),
        label: Text(selectedResource.displayName),
        onDeleted: () {
          _selectedResources.removeAt(i);
          _resourceIds.removeAt(i);
          unSelectedResources = _getUnSelectedResources(
              _selectedResources, widget.events.resources);
          setState(() {});
        },
      ));
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chipWidgets,
    );
  }
}

class AppointmentEditor extends StatefulWidget {
  const AppointmentEditor(
      this.model,
      this.selectedAppointment,
      this.targetElement,
      this.selectedDate,
      this.colorCollection,
      this.colorNames,
      this.events,
      this.timeZoneCollection,
      [this.selectedResource]);

  final SampleModel model;

  final Meeting selectedAppointment;

  final CalendarElement targetElement;

  final DateTime selectedDate;

  final List<Color> colorCollection;

  final List<String> colorNames;

  final CalendarDataSource events;

  final List<String> timeZoneCollection;

  final CalendarResource selectedResource;

  @override
  _AppointmentEditorState createState() => _AppointmentEditorState();
}

class _AppointmentEditorState extends State<AppointmentEditor> {
  int selectedColorIndex = 0;
  int selectedTimeZoneIndex = 0;
  DateTime _startDate;
  TimeOfDay startTime;
  DateTime _endDate;
  TimeOfDay endTime;
  bool isAllDay = false;
  String subject = '';
  String notes;
  String location;
  List<Object> _resourceIds;
  List<CalendarResource> _selectedResources = <CalendarResource>[];
  List<CalendarResource> unSelectedResources = <CalendarResource>[];

  final apontmentxColor = Get.put(ApointmentController());
  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(AppointmentEditor oldWidget) {
    _updateAppointmentProperties();
    super.didUpdateWidget(oldWidget);
  }

  void _updateAppointmentProperties() {
    if (widget.selectedAppointment != null) {
      _startDate = widget.selectedAppointment.from;
      _endDate = widget.selectedAppointment.to;
      isAllDay = widget.selectedAppointment.isAllDay;
      selectedColorIndex =
          widget.colorCollection.indexOf(widget.selectedAppointment.background);
      selectedTimeZoneIndex =
          widget.selectedAppointment.startTimeZone == null ||
                  widget.selectedAppointment.startTimeZone == ''
              ? 0
              : widget.timeZoneCollection
                  .indexOf(widget.selectedAppointment.startTimeZone);
      subject = widget.selectedAppointment.eventName == '(No title)' ? '' : '';
      notes = widget.selectedAppointment.description;
    } else {
      isAllDay = widget.targetElement == CalendarElement.allDayPanel;
      selectedColorIndex = 0;
      selectedTimeZoneIndex = 0;
      subject = '';
      notes = '';
      location = '';

      final DateTime date = widget.selectedDate;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 2));

      if (widget.selectedResource != null) {
        _resourceIds = <Object>[widget.selectedResource.id];
      }
    }

    startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _selectedResources =
        _getSelectedResources(_resourceIds, widget.events.resources);
    unSelectedResources =
        _getUnSelectedResources(_selectedResources, widget.events.resources);
  }

  Widget _getAppointmentEditor(
      BuildContext context, Color backgroundColor, Color defaultColor) {
    return Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Text(
                            DateFormat('EEE, MMM dd yyyy').format(_startDate),
                            textAlign: TextAlign.left),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            DateFormat('HH:mm').format(_startDate),
                            textAlign: TextAlign.right,
                          )),
                    ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Text(
                          DateFormat('EEE, MMM dd yyyy').format(_endDate),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            DateFormat('HH:mm ').format(_endDate),
                            textAlign: TextAlign.right,
                          )),
                    ])),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            if (widget.model.isWebFullView)
              const Divider(
                height: 1.0,
                thickness: 1,
              )
            else
              Container(),
            SizedBox(
              height: 50,
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
            widget.selectedAppointment == null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: widget.colorCollection[selectedColorIndex],
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 130),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String token = prefs.getString('token');

                      String color = apontmentxColor.colorsx.value;

                      String startDate =
                          DateFormat('yyyy-MM-dd HH:mm').format(_startDate);

                      await addApointment(startDate, color, token);
                      apontmentxColor.colorsx.value = "Color(0xFF12D9F3)";
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: widget.colorCollection[selectedColorIndex],
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
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Stack(
          children: <Widget>[
            _getAppointmentEditor(context, (Colors.white), Colors.white)
          ],
        ),
      ),
    );
  }

  Future addApointment(
    String time,
    String colors,
    String token,
  ) async {
    try {
      EasyLoading.show(
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.custom,
      );
      http.Response response = await http.post(
        Uri.parse(
            'http://www.bergischreinigung.de/ap.php?type=add-date&start_time=$time&colors=$colors&token=$token'),
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
      } else if ((result[0]['message'] == 'date exist')) {
        print("x${result[0]['message']}x");
        EasyLoading.showError("yor appointment exist",
            dismissOnTap: false,
            maskType: EasyLoadingMaskType.custom,
            duration: Duration(microseconds: 1500));
        Timer(Duration(microseconds: 1700), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        });
      } else {
        print("x${result[0]['message']}x");
        EasyLoading.showError(
          "error appointment not added",
          dismissOnTap: false,
          maskType: EasyLoadingMaskType.custom,
          duration: Duration(microseconds: 1500),
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

CalendarResource _getResourceFromId(
    Object resourceId, List<CalendarResource> resourceCollection) {
  return resourceCollection
      .firstWhere((CalendarResource resource) => resource.id == resourceId);
}

List<CalendarResource> _getSelectedResources(
    List<Object> resourceIds, List<CalendarResource> resourceCollection) {
  final List<CalendarResource> _selectedResources = <CalendarResource>[];
  if (resourceIds == null ||
      resourceIds.isEmpty ||
      resourceCollection == null ||
      resourceCollection.isEmpty) {
    return _selectedResources;
  }

  for (int i = 0; i < resourceIds.length; i++) {
    final CalendarResource resourceName =
        _getResourceFromId(resourceIds[i], resourceCollection);
    _selectedResources.add(resourceName);
  }

  return _selectedResources;
}

List<CalendarResource> _getUnSelectedResources(
    List<CalendarResource> selectedResources,
    List<CalendarResource> resourceCollection) {
  if (selectedResources == null ||
      selectedResources.isEmpty ||
      resourceCollection == null ||
      resourceCollection.isEmpty) {
    return resourceCollection ?? <CalendarResource>[];
  }

  final List<CalendarResource> collection = resourceCollection.sublist(0);
  for (int i = 0; i < resourceCollection.length; i++) {
    final CalendarResource resource = resourceCollection[i];
    for (int j = 0; j < selectedResources.length; j++) {
      final CalendarResource selectedResource = selectedResources[j];
      if (resource.id == selectedResource.id) {
        collection.remove(resource);
      }
    }
  }

  return collection;
}
