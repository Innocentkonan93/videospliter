import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  // 🔁 Sélection automatique des bons IDs selon la plateforme
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-5234606722270286/3509130433';
      }
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/2934735716';
      } else {
        return 'ca-app-pub-5234606722270286/9647179286';
      }
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/1033173712';
      } else {
        return 'ca-app-pub-5234606722270286/1538714850';
      }
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/4411468910';
      } else {
        return 'ca-app-pub-5234606722270286/5094816487';
      }
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/5224354917';
      } else {
        return 'ca-app-pub-5234606722270286/3688275596';
      }
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/1712485313';
      } else {
        return 'ca-app-pub-5234606722270286/7932732814';
      }
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  /// Bannière
  BannerAd loadBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => print('Banner loaded'),
        onAdFailedToLoad: (ad, err) {
          print('Banner failed: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  /// Interstitiel
  void loadInterstitialAd({Function()? onAdReady, Function()? onAdDismissed}) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
          _interstitialAd!
              .fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (onAdDismissed != null) onAdDismissed();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              // print('Interstitial failed: $error');
            },
          );
          if (onAdReady != null) {
            onAdReady(); // ✅ on déclenche l’affichage ensuite
          }
        },
        onAdFailedToLoad: (error) {
          print('Interstitial load error: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    _interstitialAd?.show();
  }

  /// Rewarded
  void loadRewardedAd({Function()? onEarnedReward}) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              print('Rewarded failed: $error');
            },
          );
          _rewardedAd!.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              print('User earned reward: ${reward.amount} ${reward.type}');
              if (onEarnedReward != null) onEarnedReward();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded load error: $error');
        },
      ),
    );
  }
}
