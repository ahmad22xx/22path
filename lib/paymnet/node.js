const functions = require("firbase_funcation");
const braintree = require('braintree');

const gateway = new braintree.BraintreeGateway({
  environment: braintree.Environment.Sandbox,
  merchantId: 'your_merchant_id',
  publicKey: 'your_public_key',
  privateKey: 'your_private_key'
});
exports.paypalPayment = functions.https.onRequest(async (req, res) => {
   const nonceFromTheClient = req.body.payment_method_nonce;
    const deviceData = req.body.device_data;
    
    gateway.transaction.sale({
  amount: '5.00',
  paymentMethodNonce: 'nonce-from-the-client',
  options: {
    submitForSettlement: true
  }
}, (err, result) => {
    if (err != null) {
      console.error(err);
    }
  
    if (result.success) {
      console.log('Transaction ID: ' + result.transaction.id);
    } else {
      res.json({
          result: 'success'
      })
    }
  }); 

});