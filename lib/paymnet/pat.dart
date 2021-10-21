// import 'package:flutter/material.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';

// class Pay extends StatefulWidget {
//   const Pay({Key key}) : super(key: key);

//   @override
//   _PayState createState() => _PayState();
// }

// class _PayState extends State<Pay> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   primary: Color.fromARGB(255, 0, 222, 233),
//                   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                   textStyle: TextStyle(fontWeight: FontWeight.bold)),
//               onPressed: () async {
//                 final request = BraintreeDropInRequest(
//                   tokenizationKey: 'sandbox_q7hstv9n_tstvrtfm32d3mmbg',
//                   // clientToken: '<Insert your client token here>',
//                   collectDeviceData: true,
//                   // googlePaymentRequest: BraintreeGooglePaymentRequest(
//                   //   totalPrice: '4.20',
//                   //   currencyCode: 'USD',
//                   //   billingAddressRequired: false,
//                   // ),
//                   paypalRequest: BraintreePayPalRequest(
//                     amount: '10',
//                     displayName: 'AOT',
//                   ),
//                 );
//                 BraintreeDropInResult result =
//                     await BraintreeDropIn.start(request);
//                 if (result != null) {
//                   print(result.paymentMethodNonce.description);
//                   print(result.paymentMethodNonce.nonce);
//                 }
//               },
//               child: Text(
//                 "Sign In",
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
