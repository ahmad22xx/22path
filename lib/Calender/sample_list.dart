import 'package:flutter/foundation.dart';

import 'samples/calendar/MView.dart';

Map<String, Function> getSampleWidget() {
  return <String, Function>{
    'appointment_editor_calendar': (Key key) => CalendarAppointmentEditor(),
  };
}
