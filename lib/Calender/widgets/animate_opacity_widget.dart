
// import 'package:flutter/material.dart';


// class AnimateOpacityWidget extends StatefulWidget {
  
  
//   const AnimateOpacityWidget({this.opacity, this.child, this.controller})
//       : assert(opacity != null),
//         assert(child != null);

  
//   final double opacity;

  
//   final Widget child;

  
//   final ScrollController controller;

//   @override
//   _AnimateOpacityWidgetState createState() => _AnimateOpacityWidgetState();
// }

// class _AnimateOpacityWidgetState extends State<AnimateOpacityWidget> {
//   double _opacity;

//   @override
//   void initState() {
//     _opacity = widget.opacity;
//     widget.controller.addListener(_onScroll);
//     super.initState();
//   }

//   void _onScroll() {
//     final double opacity = widget.controller.offset * 0.01;
//     if (opacity >= 0 && opacity <= 1) {
//       setState(() {
//         _opacity = opacity;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Opacity(opacity: _opacity, child: widget.child),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     widget.controller.removeListener(_onScroll);
//   }
// }
