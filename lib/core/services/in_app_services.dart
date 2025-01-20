import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../modules/pro_screen/pro_screen_controller.dart';

class InAppServices {
  StreamSubscription<dynamic>? _subscription;

  static const Set<String> _kIds = <String>{'weekly_invoice_pro','monthly_invoice_pro','yearly_invoice_pro','lifetime_invoice_pro'};

  void initializedPurchase(PurchaseCallback purchaseCallback) {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList, purchaseCallback);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList,
      PurchaseCallback purchaseCallback) async {
    debugPrint("_listenToPurchaseUpdated called");

    // Utils().snackBarMsg('Listen To Purchase Update', 'CALLED');

    for(var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // _handleError(purchaseDetails.error!);
          purchaseCallback.onPurchaseFailureCallback();
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);

          // Utils().snackBarMsg('Listen To Purchase Update', 'Purchased Successfully');

          purchaseCallback.onPurchaseSuccessCallback();
          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (valid) {
          //   // _deliverProduct(purchaseDetails);
          // } else {
          //   // _handleInvalidPurchase(purchaseDetails);
          // }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          purchaseCallback.onPurchaseSuccessCallback();
        }
      }
    }

    // purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    //   if (purchaseDetails.status == PurchaseStatus.pending) {
    //     // _showPendingUI();
    //   } else {
    //     if (purchaseDetails.status == PurchaseStatus.error) {
    //       // _handleError(purchaseDetails.error!);
    //       purchaseCallback.onPurchaseFailureCallback();
    //     } else if (purchaseDetails.status == PurchaseStatus.purchased ||
    //         purchaseDetails.status == PurchaseStatus.restored) {
    //       await InAppPurchase.instance.completePurchase(purchaseDetails);
    //
    //       Utils().snackBarMsg('Listen To Purchase Update', 'Purchased Successfully');
    //
    //       purchaseCallback.onPurchaseSuccessCallback();
    //       // bool valid = await _verifyPurchase(purchaseDetails);
    //       // if (valid) {
    //       //   // _deliverProduct(purchaseDetails);
    //       // } else {
    //       //   // _handleInvalidPurchase(purchaseDetails);
    //       // }
    //     }
    //     if (purchaseDetails.pendingCompletePurchase) {
    //       await InAppPurchase.instance.completePurchase(purchaseDetails);
    //     }
    //   }
    // });
  }

  Future<List<ProductDetails>> getStoreProducts() async {
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
    }
    List<ProductDetails> products = response.productDetails;
    debugPrint("InAPP Products:: $products");

    return products;

  }

  void buyProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    debugPrint(purchaseParam.productDetails.id);

    await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam).catchError((err) => debugPrint("Error $err"));

    // Utils().snackBarMsg('Buy Product Dialogue Open', 'From In App Purchase Services');

  }


  // void buyTestProduct(PurchaseCallback purchaseCallback){
  //
  //   purchaseCallback.onPurchaseSuccessCallback();
  //
  // }
}
