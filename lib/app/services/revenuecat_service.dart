import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:video_spliter/app/widgets/premium_success_view.dart';

class RevenueCatService extends GetxService {
  static const String _androidApiKey = "goog_BEgzcIzQuqrLjGZaSnfLEjSqpNV";
  static const String _iosApiKey = "appl_NycGQMwdBmSQQHlkJxhLwBKhxWC";
  static const String entitlementId = "Cutit Pro";
  static const String monthlyProduct = "cutit_monthly";
  static const String yearlyProduct = "cutit_yearly";

  final isProUser = false.obs;

  Future<RevenueCatService> init() async {
    try {
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      } else {
        await Purchases.setLogLevel(LogLevel.error);
      }

      String apiKey = "";
      if (Platform.isAndroid) {
        apiKey = _androidApiKey;
      } else if (Platform.isIOS || Platform.isMacOS) {
        apiKey = _iosApiKey;
      }

      if (apiKey.isNotEmpty) {
        await Purchases.configure(PurchasesConfiguration(apiKey));
      }

      // Listen for subscription status changes
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        _updateSubscriptionStatus(customerInfo);
      });

      // Initial check
      await checkSubscriptionStatus();
    } catch (e) {
      debugPrint("Error initializing RevenueCat: $e");
    }

    return this;
  }

  /// Checks the current subscription status
  Future<void> checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updateSubscriptionStatus(customerInfo);
    } catch (e) {
      debugPrint("Error fetching customer info: $e");
    }
  }

  /// Updates the reactive state based on CustomerInfo
  void _updateSubscriptionStatus(CustomerInfo customerInfo) {
    if (customerInfo.entitlements.all[entitlementId] != null &&
        customerInfo.entitlements.all[entitlementId]!.isActive) {
      isProUser.value = true;
      debugPrint("User has active '\$entitlementId' entitlement.");
    } else {
      isProUser.value = false;
      debugPrint("User does NOT have active '\$entitlementId' entitlement.");
    }
  }

  /// Present the full paywall
  Future<void> presentPaywall() async {
    try {
      final paywallResult = await RevenueCatUI.presentPaywallIfNeeded(
        entitlementId,
      );
      if (paywallResult == PaywallResult.purchased ||
          paywallResult == PaywallResult.restored) {
        Get.off(() => const PremiumSuccessView());
      } else if (paywallResult == PaywallResult.notPresented) {
        Get.snackbar("info".tr, "already_pro".tr);
      }
    } catch (e) {
      debugPrint("Error presenting paywall: $e");
    }
  }

  /// Present the paywall only if the user doesn't have the entitlement
  Future<void> presentPaywallIfNeeded() async {
    try {
      final paywallResult = await RevenueCatUI.presentPaywallIfNeeded(
        entitlementId,
      );
      if (paywallResult == PaywallResult.purchased ||
          paywallResult == PaywallResult.restored) {
        Get.to(() => const PremiumSuccessView());
      }
    } catch (e) {
      debugPrint("Error presenting paywall: $e");
    }
  }

  /// Fetches current offerings setup in RevenueCat
  Future<Offerings?> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        return offerings;
      }
    } catch (e) {
      debugPrint("Error fetching offerings: \$e");
    }
    return null;
  }

  /// Purchase a specific package programmatically (if you build your own UI instead of using the paywall)
  Future<bool> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      _updateSubscriptionStatus(customerInfo.customerInfo);
      return customerInfo
              .customerInfo
              .entitlements
              .all[entitlementId]
              ?.isActive ==
          true;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint("Purchase error: \$e");
        Get.snackbar("Error", "We had a problem during the purchase process.");
      }
      return false;
    }
  }

  /// Restore purchases (usually a button in Paywall or settings)
  Future<void> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      log(customerInfo.toString());
      _updateSubscriptionStatus(customerInfo);

      if (customerInfo.entitlements.all[entitlementId] != null &&
          customerInfo.entitlements.all[entitlementId]!.isActive) {
        Get.off(() => const PremiumSuccessView());
      } else {
        Get.snackbar(
          "info".tr,
          "no_active_subscription".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint("Restore purchases error: \$e");
        Get.snackbar("Error", "Failed to restore purchases.");
      }
    }
  }

  /// Present RevenueCat Customer Center to let users manage their subscriptions
  Future<void> showCustomerCenter() async {
    try {
      await RevenueCatUI.presentCustomerCenter();
    } catch (e) {
      debugPrint("Error presenting customer center: \$e");
      Get.snackbar("Error", "Could not open Customer Center.");
    }
  }
}
