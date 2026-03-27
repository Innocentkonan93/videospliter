import 'package:get/get.dart';
import 'package:video_spliter/app/services/config_service.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';

class FeatureManager {
  /// Indique si la version Pro est activée globalement via Remote Config.
  /// Si cette valeur est fausse, tout le système Pro (paywalls, fonctionnalités premium)
  /// sera masqué ou désactivé, même pour les anciens utilisateurs Pro.
  static bool get isProVersionAvailable => ConfigService.isProEnabled;

  /// Indique si l'utilisateur actuel a accès aux fonctionnalités Pro.
  /// Cela combine le Feature Flag (Remote Config) et le statut d'abonnement (RevenueCat).
  static bool get isProUser {
    // Si la version Pro est désactivée globalement, personne n'est considéré comme Pro.
    if (!isProVersionAvailable) return false;

    // Sinon, on vérifie le statut RevenueCat.
    return Get.find<RevenueCatService>().isProUser.value;
  }

  /// Version réactive pour l'utilisation dans les widgets via Obx
  static RxBool get isProUserRx {
    final proAvailable = ConfigService.isProEnabled;
    if (!proAvailable) return false.obs;
    return Get.find<RevenueCatService>().isProUser;
  }

  /// Indique si on doit afficher les éléments liés à la monétisation (paywalls, upsells).
  static bool get shouldShowProContent =>
      isProVersionAvailable && !Get.find<RevenueCatService>().isProUser.value;
}
