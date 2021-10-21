import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ApointmentController extends GetxController {
  var datex = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0)
      .obs;
  // final durationx = 3.obs;
  // final startWork = 3.obs;
  // final endWork = 3.obs;
  // final statue = 1.obs;
  final colorsx = "Color(0xFF12D9F3)".obs;
  final List<Appointment> appo = <Appointment>[].obs;
  final viewNumber = 0.obs;

  @override
  void onInit() {
    colorsx.value = "Color(0xFF12D9F3)";
    super.onInit();
  }
}
