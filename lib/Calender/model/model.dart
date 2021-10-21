import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../sample_list.dart';

class WidgetCategory {
  WidgetCategory(
      [this.categoryName,
      this.controlList,
      this.mobileCategoryId,
      this.webCategoryId,
      this.platformsToHide]);

  factory WidgetCategory.fromJson(Map<String, dynamic> json) {
    return WidgetCategory(
        json['categoryName'],
        json['controlList'],
        json['mobileCategoryId'],
        json['webCategoryId'],
        json['platformsToHide']);
  }

  String categoryName;

  List<dynamic> controlList;

  final int mobileCategoryId;

  final int webCategoryId;

  int selectedIndex = 0;

  final List<dynamic> platformsToHide;
}

class Control {
  Control(
      this.title,
      this.description,
      this.image,
      this.status,
      this.displayType,
      this.subItems,
      this.controlId,
      this.isBeta,
      this.platformsToHide);

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
        json['title'],
        json['description'],
        json['image'],
        json['status'],
        json['displayType'],
        json['subItems'],
        json['controlId'],
        json['isBeta'],
        json['platformsToHide']);
  }

  final String title;

  final String description;

  final String image;

  final String status;

  final int controlId;

  final String displayType;

  List<SubItem> sampleList;

  List<SubItem> childList;

  List<dynamic> subItems;

  final bool isBeta;

  final List<dynamic> platformsToHide;
}

class SubItem {
  SubItem(
      [this.type,
      this.displayType,
      this.title,
      this.key,
      this.codeLink,
      this.description,
      this.status,
      this.subItems,
      this.sourceLink,
      this.sourceText,
      this.needsPropertyPanel,
      this.platformsToHide]);

  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
        json['type'],
        json['displayType'],
        json['title'],
        json['key'],
        json['codeLink'],
        json['description'],
        json['status'],
        json['subItems'],
        json['sourceLink'],
        json['sourceText'],
        json['needsPropertyPanel'],
        json['platformsToHide']);
  }

  final String type;

  final String displayType;

  final String title;

  final String key;

  final String codeLink;

  final String description;

  final String status;

  final String sourceLink;

  final String sourceText;

  List<dynamic> subItems;

  final bool needsPropertyPanel;

  String categoryName;

  String breadCrumbText;

  int parentIndex;

  int childIndex;

  int sampleIndex;

  Control control;

  final List<dynamic> platformsToHide;
}

class SampleModel extends Listenable {
  SampleModel() {
    searchControlItems = <Control>[];
    sampleList = <SubItem>[];
    searchResults = <SubItem>[];
    searchSampleItems = <SubItem>[];
    categoryList = SampleModel._categoryList;
    controlList = SampleModel._controlList;
    routes = SampleModel._routes;
    searchControlItems.addAll(controlList);
    for (int index = 0; index < controlList.length; index++) {
      if (controlList[index].sampleList = null) {
        for (int i = 0; i < controlList[index].sampleList.length; i++) {
          searchSampleItems.add(controlList[index].sampleList[i]);
        }
      } else if (controlList[index].childList = null) {
        for (int i = 0; i < controlList[index].childList.length; i++) {
          for (int j = 0;
              j < controlList[index].childList[i].subItems.length;
              j++) {
            if (controlList[index].childList[i].subItems[j].type =
                'child' != null) {
              searchSampleItems
                  .add(controlList[index].childList[i].subItems[j]);
            } else {
              for (final SubItem sample
                  in controlList[index].childList[i].subItems[j].subItems) {
                searchSampleItems.add(sample);
              }
            }
          }
        }
      } else {
        for (int i = 0; i < controlList[index].subItems.length; i++) {
          for (int j = 0;
              j < controlList[index].subItems[i].subItems.length;
              j++) {
            for (int k = 0;
                k < controlList[index].subItems[i].subItems[j].subItems.length;
                k++) {
              searchSampleItems
                  .add(controlList[index].subItems[i].subItems[j].subItems[k]);
            }
          }
        }
      }
    }
  }

  static SampleModel instance = SampleModel();

  final Map<String, Function> sampleWidget = getSampleWidget();

  static List<Control> _controlList = <Control>[];

  static List<WidgetCategory> _categoryList = <WidgetCategory>[];

  List<WidgetCategory> categoryList;

  List<Control> controlList;

  List<Control> searchControlItems;

  List<SubItem> sampleList;

  List<SubItem> searchSampleItems;

  List<SubItem> searchResults;

  Color backgroundColor = const Color.fromRGBO(0, 116, 227, 1);

  Color paletteColor = const Color.fromRGBO(0, 116, 227, 1);

  Color currentPrimaryColor = const Color.fromRGBO(0, 116, 227, 1);

  ThemeData themeData;

  Color textColor = const Color.fromRGBO(51, 51, 51, 1);

  Color drawerTextIconColor = Colors.black;

  Color bottomSheetBackgroundColor = Colors.white;

  Color cardThemeColor = Colors.white;

  Color webBackgroundColor = const Color.fromRGBO(246, 246, 246, 1);

  Color webIconColor = const Color.fromRGBO(0, 0, 0, 0.54);

  Color webInputColor = const Color.fromRGBO(242, 242, 242, 1);

  Color webOutputContainerColor = Colors.white;

  Color cardColor = Colors.white;

  Color dividerColor = const Color.fromRGBO(204, 204, 204, 1);

  Size oldWindowSize;

  Size currentWindowSize;

  static List<SampleRoute> _routes = <SampleRoute>[];

  List<SampleRoute> routes;

  dynamic currentRenderSample;

  String currentSampleKey;

  List<Color> paletteColors;

  List<Color> paletteBorderColors;

  List<Color> darkPaletteColors;

  ThemeData currentThemeData;

  Color currentPaletteColor = const Color.fromRGBO(0, 116, 227, 1);

  int selectedThemeIndex = 0;

  bool isCardView = true;

  bool isMobileResolution;

  ThemeData systemTheme;

  TextEditingController editingController = TextEditingController();

  GlobalKey<State> propertyPanelKey;

  bool needToMaximize = false;

  dynamic outputContainerState;

  bool isWebFullView = false;

  bool isMobile = false;

  bool isWeb = false;

  bool isDesktop = false;

  bool isAndroid = false;

  bool isWindows = false;

  bool isIOS = false;

  bool isLinux = false;

  bool isMacOS = false;

  bool isPropertyPanelOpened = true;

  SampleRoute currentSampleRoute;

  static List<SampleRoute> sampleRoutes = <SampleRoute>[];

  void changeTheme(ThemeData _themeData) {
    themeData = _themeData;
    switch (_themeData.brightness) {
      case Brightness.dark:
        {
          dividerColor = const Color.fromRGBO(61, 61, 61, 1);
          cardColor = const Color.fromRGBO(48, 48, 48, 1);
          webIconColor = const Color.fromRGBO(255, 255, 255, 0.65);
          webOutputContainerColor = const Color.fromRGBO(23, 23, 23, 1);
          webInputColor = const Color.fromRGBO(44, 44, 44, 1);
          webBackgroundColor = const Color.fromRGBO(33, 33, 33, 1);
          drawerTextIconColor = Colors.white;
          bottomSheetBackgroundColor = const Color.fromRGBO(34, 39, 51, 1);
          textColor = const Color.fromRGBO(242, 242, 242, 1);
          cardThemeColor = const Color.fromRGBO(33, 33, 33, 1);
          break;
        }
      default:
        {
          dividerColor = const Color.fromRGBO(204, 204, 204, 1);
          cardColor = Colors.white;
          webIconColor = const Color.fromRGBO(0, 0, 0, 0.54);
          webOutputContainerColor = Colors.white;
          webInputColor = const Color.fromRGBO(242, 242, 242, 1);
          webBackgroundColor = const Color.fromRGBO(246, 246, 246, 1);
          drawerTextIconColor = Colors.black;
          bottomSheetBackgroundColor = Colors.white;
          textColor = const Color.fromRGBO(51, 51, 51, 1);
          cardThemeColor = Colors.white;
          break;
        }
    }
  }

  final Set<VoidCallback> _listeners = Set<VoidCallback>();
  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  @protected
  void notifyListeners() {
    _listeners.toList().forEach((VoidCallback listener) => listener());
  }
}

class SampleRoute {
  SampleRoute(
      {this.routeName,
      this.subItem,
      this.currentContext,
      this.currentState,
      this.currentWidget,
      this.globalKey});

  final SubItem subItem;

  final GlobalKey<State> globalKey;

  String routeName;

  State currentState;

  BuildContext currentContext;

  Widget currentWidget;
}
