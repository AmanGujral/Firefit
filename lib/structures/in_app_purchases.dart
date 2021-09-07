import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:myfitnessfire/structures/user_model.dart';

class InAppPurchases {

  /// Is the API available on the device
  bool _available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Products for sale
  static List<ProductDetails> _products = [];

  /// Past purchases
  static List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  static StreamSubscription _subscription;

  List<String> productIds = [];
  List<String> productIdsLowerCase = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel _userInstance = UserModel().getInstance();

  Future<bool> initialize(List<String> programIds) async {

    // Check availability of In App Purchases
    _available = await _iap.isAvailable();

    // Program IDs
    productIds = programIds;

    // Product IDs
    productIds.forEach((element) {
      productIdsLowerCase.add(element.toLowerCase());
    });

    if (_available) {

      await _getProducts();
      await _getPastPurchases();

      // Verify and deliver a purchase with your own business logic
      _purchases.forEach((element) {
        _verifyPastPurchase(element.productID);
      });

      // Listen to new purchases
      _subscription = _iap.purchaseUpdatedStream.listen((data) {
        _purchases.addAll(data);
        /*data.forEach((element) {
          _verifyPastPurchase(element.productID);
        });*/
      });

      return true;
    }
    else
      return false;
  }

  /// Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from(productIdsLowerCase);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    _products = response.productDetails;
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response =
    await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if(Platform.isIOS){
        _iap.completePurchase(purchase);
      }
    }

    _purchases = response.pastPurchases;
  }

  /// Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere( (purchase) => purchase.productID == productID.toLowerCase(), orElse: () => null);
  }

  /// Verify past purchases
  Future<bool> _verifyPastPurchase(String productID) async {
    PurchaseDetails purchase = _hasPurchased(productID);
    bool result = false;

    await _firestore.collection("Users")
        .doc(_userInstance.userId)
        .collection("purchased")
        .where("programId", isEqualTo: productID)
        .get()
        .then((QuerySnapshot snapshot) => (
        snapshot.docs.forEach((doc) {
          if(doc.exists && doc.id == productID && purchase != null && purchase.status == PurchaseStatus.purchased){
            result = true;
          }
        })
    ));

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      result = true;
    }
    return result;
  }

  /// Verify new product purchases
  Future<bool> _verifyNewPurchase(String productID) async {
    PurchaseDetails purchase = _hasPurchased(productID);
    bool result = false;

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      result = true;
    }
    return result;
  }

  Future<bool> buyProduct(String productId) async {
    ProductDetails product = _products.firstWhere((prod) => prod.id == productId.toLowerCase(), orElse: () => null);

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);

    return await _verifyNewPurchase(productId);
  }


  void cancelSubscription() {
    _subscription.cancel();
  }
}