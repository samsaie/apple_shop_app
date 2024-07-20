import 'package:apple_shop_app/util/extensions/string_extensions.dart';
import 'package:apple_shop_app/util/url_handler.dart';
import 'package:uni_links/uni_links.dart';
import 'package:zarinpal/zarinpal.dart';

abstract class PaymentHandler {
  Future<void> initPaymentRequest(int finalPrice);
  Future<void> sendPaymentRequest();
  Future<void> verifyPaymentRequest();
}

class ZarinpalPaymentHandler extends PaymentHandler {
  final PaymentRequest _paymentRequest = PaymentRequest();
  String? _authority;
  String? _status;
  UrlHandler urlHandler;
  ZarinpalPaymentHandler(this.urlHandler);

  @override
  Future<void> initPaymentRequest(int finalPrice) async {
    // baraye estefade az zarinpal vagheee bejaye true , false mizarim
    _paymentRequest.setIsSandBox(true);
    _paymentRequest.setAmount(finalPrice);
    _paymentRequest.setDescription('this is for test application apple shop');
    _paymentRequest.setCallbackURL('expertflutter://shop');
    _paymentRequest.setMerchantID('d645fba8-1b29-11ea-be59-000c295eb8fc');
    linkStream.listen((deeplink) {
      if (deeplink!.toLowerCase().contains('authority')) {
        _authority = deeplink.extractValueFromQuery('Authority');
        _status = deeplink.extractValueFromQuery('Status');
        verifyPaymentRequest();
      }
    });
  }

  @override
  Future<void> sendPaymentRequest() async {
    ZarinPal().startPayment(_paymentRequest, (status, paymentGatewayUri) {
      if (status == 100) {
        urlHandler.openUrl(paymentGatewayUri!);
      }
    });
  }

  @override
  Future<void> verifyPaymentRequest() async {
    ZarinPal().verificationPayment(_status!, _authority!, _paymentRequest,
        (isPaymentSuccess, refID, paymentRequest) {
      if (isPaymentSuccess) {
        print(refID);
      } else {
        print('error');
      }
    });
  }
}


// class PaypalPaymentHandler extends PaymentHandler {
//   @override
//   Future<void> initPaymentRequest() async {}

//   @override
//   Future<void> sendPaymentRequest() async {}

//   @override
//   Future<void> verifyPaymentRequest() async {}
// }