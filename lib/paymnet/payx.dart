import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:http/http.dart' as http;

class Payxx extends StatefulWidget {
  @override
  _PayxxState createState() => _PayxxState();
}

class _PayxxState extends State<Payxx> {
  static final String tokenizationKey = 'sandbox_8hccj7nq_v8d2ch9m6m6bd8s6';
  var url = 'https://us-central1-tesxt-d2aa1.cloudfunctions.net/paypalPayment';

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
            // SizedBox(height: 16),
            // Text('Description: ${result.deviceData}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braintree example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                var request = BraintreeDropInRequest(
                  tokenizationKey: tokenizationKey,
                  collectDeviceData: true,
                  paypalRequest: BraintreePayPalRequest(
                    amount: '10.00',
                    displayName: 'Example company',
                  ),
                  cardEnabled: true,
                );
                BraintreeDropInResult result =
                    await BraintreeDropIn.start(request);
                print(result.paymentMethodNonce.nonce);
                print(result.deviceData);
                if (result != null) {
                  try {
                    http.Response response = await http.post(Uri.tryParse(
                        '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}'));
                    print(response.body);
                    final payResult = jsonDecode(response.body);
                    if (payResult['result'] == 'success') {
                      print("payment done");
                    } else {
                      print("error");
                    }
                  } catch (e) {
                    print(e);
                  }
                }
                //         http.Response response =
                // await http.post(Uri.tryParse('$url?paymentMethodNonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}'));
              },
              child: Text('LAUNCH NATIVE DROP-IN'),
            ),
            ElevatedButton(
              onPressed: () async {
                final request = BraintreeCreditCardRequest(
                  cardNumber: '4111111111111111',
                  expirationMonth: '12',
                  expirationYear: '2021',
                  cvv: '123',
                );
                final result = await Braintree.tokenizeCreditCard(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('TOKENIZE CREDIT CARD'),
            ),
            ElevatedButton(
              onPressed: () async {
                final request = BraintreePayPalRequest(
                  billingAgreementDescription:
                      'I hereby agree that flutter_braintree is great.',
                  displayName: 'Your Company',
                );
                final result = await Braintree.requestPaypalNonce(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('PAYPAL VAULT FLOW'),
            ),
            ElevatedButton(
              onPressed: () async {
                final request = BraintreePayPalRequest(amount: '13.37');
                final result = await Braintree.requestPaypalNonce(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('PAYPAL CHECKOUT FLOW'),
            ),
          ],
        ),
      ),
    );
  }
}
