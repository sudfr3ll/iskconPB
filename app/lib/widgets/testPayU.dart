import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';

Map<String, dynamic> model = <String, dynamic>{};

class MyPayU extends StatefulWidget {
  const MyPayU({super.key});

  @override
  State<MyPayU> createState() => _MyPayUState();
}

class _MyPayUState extends State<MyPayU> implements PayUCheckoutProProtocol {
  late PayUCheckoutProFlutter _checkoutPro;

  @override
  void initState() {
    super.initState();
    _checkoutPro = PayUCheckoutProFlutter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayU Checkout Pro'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Start Payment"),
          onPressed: () async {
            _checkoutPro.openCheckoutScreen(
              payUPaymentParams: PayUParams.createPayUPaymentParams(),
              payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
            );
          },
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(content),
            ),
            actions: [okButton],
          );
        });
  }

  @override
  generateHash(Map response) async {
    // Pass response param to your backend server
    // Backend will generate the hash and will callback to
    model['key'] = 'gtKFFx';
    model['docId'] = '6001';
    model['productinfo'] = 'Info';
    model['firstname'] = 'Rishabh';
    model['lastname'] = 'kumar';
    model['phone'] = '9999999999';
    model['email'] = 'abc@gmail.com';
    model['amount'] = double.parse('1000.00').toDouble().toString();
    // model['iosSurl'] =
    //     "https://payu.herokuapp.com/ios_success"; //TODO: Add Success URL.
    // model['iosFurl'] =
    //     "https://payu.herokuapp.com/ios_failure"; //TODO Add Fail URL.
    // model['androidSurl'] =
    //     "https://payu.herokuapp.com/success"; //TODO: Add Success URL.
    // model['androidFurl'] = "https://payu.herokuapp.com/failure"; //
    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('payments-generateSHA512Response');
    try {
      final results = await callable.call(response);
      print(results.data);
      _checkoutPro.hashGenerated(hash: results.data);
    } catch (e) {
      print(e);
    }

    // Map hashResponse = HashService.generateHash(response);
    // _checkoutPro.hashGenerated(hash: results);
  }

  @override
  onPaymentSuccess(dynamic response) {
    showAlertDialog(context, "onPaymentSuccess", response.toString());
  }

  @override
  onPaymentFailure(dynamic response) {
    showAlertDialog(context, "onPaymentFailure", response.toString());
  }

  @override
  onPaymentCancel(Map? response) {
    showAlertDialog(context, "onPaymentCancel", response.toString());
  }

  @override
  onError(Map? response) {
    showAlertDialog(context, "onError", response.toString());
  }
}

class PayUTestCredentials {
  static const merchantKey = "gtKFFx"; //TODO: Add Merchant Key
  //Use your success and fail URL's.

  static const iosSurl =
      "https://payu.herokuapp.com/ios_success"; //TODO: Add Success URL.
  static const iosFurl =
      "https://payu.herokuapp.com/ios_failure"; //TODO Add Fail URL.
  static const androidSurl =
      "https://payu.herokuapp.com/success"; //TODO: Add Success URL.
  static const androidFurl =
      "https://payu.herokuapp.com/failure"; //TODO Add Fail URL.

  static const merchantAccessKey =
      ""; //TODO: Add Merchant Access Key - Optional
  static const sodexoSourceId = ""; //TODO: Add sodexo Source Id - Optional
}

//Pass these values from your app to SDK, this data is only for test purpose
class PayUParams {
  static Map createPayUPaymentParams() {
    var siParams = {
      PayUSIParamsKeys.isFreeTrial: true,
      PayUSIParamsKeys.billingAmount: '1', //Required
      PayUSIParamsKeys.billingInterval: 1, //Required
      PayUSIParamsKeys.paymentStartDate: '2023-04-20', //Required
      PayUSIParamsKeys.paymentEndDate: '2023-04-30', //Required
      PayUSIParamsKeys.billingCycle: //Required
          'daily', //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
      PayUSIParamsKeys.remarks: 'Test SI transaction',
      PayUSIParamsKeys.billingCurrency: 'INR',
      PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
      PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
    };

    var additionalParam = {
      PayUAdditionalParamKeys.udf1: "udf1",
      PayUAdditionalParamKeys.udf2: "udf2",
      PayUAdditionalParamKeys.udf3: "udf3",
      PayUAdditionalParamKeys.udf4: "udf4",
      PayUAdditionalParamKeys.udf5: "udf5",
      PayUAdditionalParamKeys.merchantAccessKey:
          PayUTestCredentials.merchantAccessKey,
      PayUAdditionalParamKeys.sourceId: PayUTestCredentials.sodexoSourceId,
    };

    var spitPaymentDetails = {
      "type": "absolute",
      "splitInfo": {
        PayUTestCredentials.merchantKey: {
          "aggregatorSubTxnId":
              "1234567540099887766650092", //unique for each transaction
          "aggregatorSubAmt": "1"
        },
        /* "qOoYIv": {
          "aggregatorSubTxnId": "12345678",
          "aggregatorSubAmt": "40"
       },*/
      }
    };

    var payUPaymentParams = {
      PayUPaymentParamKey.key: 'gtKFFx',
      PayUPaymentParamKey.amount: "1",
      PayUPaymentParamKey.productInfo: "Info",
      PayUPaymentParamKey.firstName: "Abc",
      PayUPaymentParamKey.email: "test@gmail.com",
      PayUPaymentParamKey.phone: "9999999999",
      PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl,
      PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl,
      PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl,
      PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl,
      PayUPaymentParamKey.environment: "0", //0 => Production 1 => Test
      PayUPaymentParamKey.userCredential:
          null, //TODO: Pass user credential to fetch saved cards => A:B - Optional
      PayUPaymentParamKey.transactionId:
          '6001',
      // PayUPaymentParamKey.additionalParam: additionalParam,
      // PayUPaymentParamKey.enableNativeOTP: true,
      // PayUPaymentParamKey.splitPaymentDetails:json.encode(spitPaymentDetails),
      // PayUPaymentParamKey.userToken:
      //     "", //TODO: Pass a unique token to fetch offers. - Optional
    };
    return payUPaymentParams;
  }

  static Map createPayUConfigParams() {
    var paymentModesOrder = [
      {"Wallets": "PHONEPE"},
      {"UPI": "TEZ"},
      {"Wallets": ""},
      {"EMI": ""},
      {"NetBanking": ""},
    ];

    var cartDetails = [
      {"GST": "5%"},
      {"Delivery Date": "25 Dec"},
      {"Status": "In Progress"}
    ];
    var enforcePaymentList = [
      {"payment_type": "CARD", "enforce_ibiboCode": "UTIBENCC"},
    ];

    var customNotes = [
      {
        "custom_note": "Its Common custom note for testing purpose",
        "custom_note_category": [
          PayUPaymentTypeKeys.emi,
          PayUPaymentTypeKeys.card
        ]
      },
      {
        "custom_note": "Payment options custom note",
        "custom_note_category": null
      }
    ];

    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "PayU",
      PayUCheckoutProConfigKeys.merchantLogo: "logo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      PayUCheckoutProConfigKeys.cartDetails: cartDetails,
      PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      // PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 30000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,
    };
    return payUCheckoutProConfig;
  }
}
