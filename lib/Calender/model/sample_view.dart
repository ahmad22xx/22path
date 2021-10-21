import 'package:flutter/material.dart';

import 'model.dart';

abstract class SampleView extends StatefulWidget {
  const SampleView({Key key}) : super(key: key);
}

abstract class SampleViewState extends State<SampleView> {
  SampleModel model;

  bool isCardView;

  @override
  void initState() {
    model = SampleModel.instance;
    isCardView = model.isCardView && !model.isWebFullView;
    super.initState();
  }

  @override
  void dispose() {
    model.isCardView = true;
    super.dispose();
  }

  Widget buildSettings(BuildContext context) {
    return null;
  }
}

class ChartSampleData {
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  final dynamic x;

  final num y;

  final dynamic xValue;

  final num yValue;

  final num secondSeriesYValue;

  final num thirdSeriesYValue;

  final Color pointColor;

  final num size;

  final String text;

  final num open;

  final num close;

  final num low;

  final num high;

  final num volume;
}

class SalesData {
  SalesData(this.x, this.y, [this.date, this.color]);

  final dynamic x;

  final dynamic y;

  final Color color;

  final DateTime date;
}
