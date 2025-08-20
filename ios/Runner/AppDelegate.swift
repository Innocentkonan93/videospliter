import Firebase
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Configuration Firebase
    FirebaseApp.configure()

    // Configuration du MethodChannel pour le partage de vidéos
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let sharingChannel = FlutterMethodChannel(
      name: "com.meetsum.cutit/sharing",
      binaryMessenger: controller.binaryMessenger)

    sharingChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

      switch call.method {
      case "getSharedVideo":
        self.getSharedVideo(result: result)
      case "clearSharedVideo":
        self.clearSharedVideo(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  // MARK: - Gestion des URLs personnalisées

  /// Gère l'ouverture de l'application via URL personnalisée (cutit://)
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {

    print("📱 AppDelegate: URL reçue: \(url)")

    // Vérifier si c'est une URL de notre app
    if url.scheme == "cutit" {
      print("📱 AppDelegate: URL cutit reçue, traitement en cours...")

      // Notifier Flutter que l'app a été ouverte via URL
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.notifyFlutterAboutURL(url: url)
      }

      return true
    }

    return false
  }

  /// Notifie Flutter qu'une URL a été reçue
  private func notifyFlutterAboutURL(url: URL) {
    guard let controller = window?.rootViewController as? FlutterViewController else { return }

    let sharingChannel = FlutterMethodChannel(
      name: "com.meetsum.cutit/sharing",
      binaryMessenger: controller.binaryMessenger)

    // Envoyer un message à Flutter pour indiquer que l'app a été ouverte via URL
    sharingChannel.invokeMethod("onAppOpenedViaURL", arguments: url.absoluteString)

    print("📱 AppDelegate: Flutter notifié de l'ouverture via URL")
  }

  /// Récupère la vidéo partagée depuis UserDefaults
  private func getSharedVideo(result: @escaping FlutterResult) {
    if let userDefaults = UserDefaults(suiteName: "group.com.meetsum.cutit") {
      if let videoUrl = userDefaults.string(forKey: "shared_video_url") {
        // Vérifier si la vidéo a été partagée récemment (dans les 30 dernières secondes)
        let timestamp = userDefaults.double(forKey: "shared_video_timestamp")
        let currentTime = Date().timeIntervalSince1970

        if currentTime - timestamp < 30 {  // 30 secondes de validité
          print("📱 AppDelegate: Vidéo partagée trouvée: \(videoUrl)")

          // Lancer l'application si elle n'est pas déjà au premier plan
          if UIApplication.shared.applicationState != .active {
            DispatchQueue.main.async {
              UIApplication.shared.open(
                URL(string: "cutit://shared-video")!, options: [:], completionHandler: nil)
            }
          }

          result(videoUrl)
        } else {
          print("📱 AppDelegate: Vidéo partagée expirée")
          result(nil)
        }
      } else {
        print("📱 AppDelegate: Aucune vidéo partagée trouvée")
        result(nil)
      }
    } else {
      print("❌ AppDelegate: Impossible d'accéder à UserDefaults partagé")
      result(
        FlutterError(
          code: "UNAVAILABLE", message: "UserDefaults partagé non accessible", details: nil))
    }
  }

  /// Nettoie les données de vidéo partagée
  private func clearSharedVideo(result: @escaping FlutterResult) {
    if let userDefaults = UserDefaults(suiteName: "group.com.meetsum.cutit") {
      userDefaults.removeObject(forKey: "shared_video_url")
      userDefaults.removeObject(forKey: "shared_video_timestamp")
      userDefaults.removeObject(forKey: "shared_video_data")
      userDefaults.synchronize()

      print("🧹 AppDelegate: Données de vidéo partagée nettoyées")
      result(true)
    } else {
      print("❌ AppDelegate: Impossible d'accéder à UserDefaults partagé")
      result(
        FlutterError(
          code: "UNAVAILABLE", message: "UserDefaults partagé non accessible", details: nil))
    }
  }

}
