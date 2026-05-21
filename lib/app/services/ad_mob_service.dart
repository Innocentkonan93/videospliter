import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_spliter/app/services/feature_manager.dart';

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

  String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/9257395921';
      } else {
        return 'ca-app-pub-5234606722270286/3574935696';
      }
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/5575463023';
      } else {
        return 'ca-app-pub-5234606722270286/8927480511';
      }
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  AppOpenAd? _appOpenAd;
  bool _isAppOpenAdShowing = false;
  DateTime? _appOpenLoadTime;

  // Public getters
  BannerAd? get bannerAd => _bannerAd;
  bool get isBannerAdLoaded => _isBannerAdLoaded;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _preloadInterstitialAd();
    _preloadAppOpenAd();
    _preloadRewardedAd();
  }

  /// Bannière (Chargée une seule fois et gardée en mémoire)
  void loadBannerAd({Function()? onAdLoadedCallback}) {
    if (FeatureManager.isProUser) {
      return;
    }

    // Libérer l'ancienne bannière si elle existe pour éviter les fuites de mémoire
    // et les exceptions JNI sur une Activité Android recréée ou obsolète
    if (_bannerAd != null) {
      _bannerAd!.dispose();
      _bannerAd = null;
      _isBannerAdLoaded = false;
    }

    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('✅ Global Banner loaded');
          _isBannerAdLoaded = true;
          if (onAdLoadedCallback != null) onAdLoadedCallback();
        },
        onAdFailedToLoad: (ad, err) {
          print('❌ Global Banner failed: $err');
          _isBannerAdLoaded = false;
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );
    _bannerAd!.load();
  }

  /// Permet de supprimer la bannière si l'utilisateur passe Pro en cours de route
  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdLoaded = false;
  }

  /// Interstitiel (Préchargement en arrière-plan)
  void _preloadInterstitialAd() {
    if (FeatureManager.isProUser) {
      return;
    }

    if (_isInterstitialAdReady) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _interstitialAd!.setImmersiveMode(true);

          _interstitialAd!
              .fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdReady = false;
              _interstitialAd = null;
              // Recharge la prochaine pub silencieusement une fois celle-ci fermée
              _preloadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Interstitial failed to show: $error');
              ad.dispose();
              _isInterstitialAdReady = false;
              _interstitialAd = null;
              _preloadInterstitialAd(); // Retente le préchargement
            },
          );
          print('✅ Interstitial preloaded successfully.');
        },
        onAdFailedToLoad: (error) {
          print('❌ Interstitial load error: $error');
          _isInterstitialAdReady = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Appelé par le reste de l'app pour afficher la pub
  void showInterstitialAd({Function()? onAdClosed}) {
    if (FeatureManager.isProUser) {
      if (onAdClosed != null) onAdClosed();
      return;
    }

    if (_isInterstitialAdReady && _interstitialAd != null) {
      // Surcharge temporaire pour ce show() spécifique
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isInterstitialAdReady = false;
          _interstitialAd = null;
          if (onAdClosed != null) onAdClosed();
          _preloadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isInterstitialAdReady = false;
          _interstitialAd = null;
          if (onAdClosed != null) onAdClosed();
          _preloadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      print('⚠️ Interstitial non prêt. On continue sans bloquer.');
      if (onAdClosed != null) onAdClosed();
      // On retente un chargement pour la prochaine fois
      _preloadInterstitialAd();
    }
  }

  // Gardé pour la compatibilité avec l'ancien code, mais devrait être déprécié
  void loadInterstitialAd({Function()? onAdReady, Function()? onAdDismissed}) {
    if (_isInterstitialAdReady && onAdReady != null) {
      onAdReady();
    } else {
      if (onAdDismissed != null) onAdDismissed();
      _preloadInterstitialAd();
    }
  }

  /// Rewarded Ad (Préchargement en arrière-plan)
  void _preloadRewardedAd() {
    if (FeatureManager.isProUser) {
      return;
    }

    if (_isRewardedAdReady) return;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedAdReady = false;
              _rewardedAd = null;
              _preloadRewardedAd(); // Recharge la suivante
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              print('Rewarded failed to show: $error');
              _isRewardedAdReady = false;
              _rewardedAd = null;
              _preloadRewardedAd();
            },
          );
          print('✅ Rewarded Ad preloaded successfully.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ Rewarded load error: $error');
          _isRewardedAdReady = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Appelé pour afficher la pub récompensée (opt-in)
  void showRewardedAd({
    required Function() onEarnedReward,
    Function()? onAdClosed,
    Function()? onAdFailedToLoad,
  }) {
    if (FeatureManager.isProUser) {
      onEarnedReward();
      if (onAdClosed != null) onAdClosed();
      return;
    }

    if (_isRewardedAdReady && _rewardedAd != null) {
      // Surcharge temporaire pour ce show spécifique
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isRewardedAdReady = false;
          _rewardedAd = null;
          if (onAdClosed != null) onAdClosed();
          _preloadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isRewardedAdReady = false;
          _rewardedAd = null;
          if (onAdFailedToLoad != null)
            onAdFailedToLoad(); // En cas d'erreur de show, on peut gérer (ex: fallback)
          if (onAdClosed != null) onAdClosed();
          _preloadRewardedAd();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
          onEarnedReward();
        },
      );
    } else {
      print(
        '⚠️ Rewarded Ad non prête. Déclenchement onAdFailedToLoad fallback.',
      );
      if (onAdFailedToLoad != null) {
        onAdFailedToLoad();
      } else {
        // Fallback s'il n'y a pas de gestion d'erreur -> on donne la récompense au bénéfice du doute ?
        // Ou on refuse. Pour l'instant on refuse.
      }
      _preloadRewardedAd();
    }
  }

  /// App Open Ad (Préchargement)
  void _preloadAppOpenAd() {
    if (FeatureManager.isProUser) {
      return;
    }

    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          print('✅ App Open Ad preloaded successfully.');
        },
        onAdFailedToLoad: (error) {
          print('❌ App Open Ad failed to load: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  /// Vérifie si l'App Open Ad est encore valide (max 4h selon Google)
  bool _isAppOpenAdAvailable() {
    return _appOpenAd != null &&
        _appOpenLoadTime != null &&
        DateTime.now().difference(_appOpenLoadTime!) < const Duration(hours: 4);
  }

  /// Appelé lors de la reprise de l'application (Foreground)
  void showAppOpenAdIfAvailable({Function()? onAdClosed}) {
    if (FeatureManager.isProUser) {
      if (onAdClosed != null) onAdClosed();
      return;
    }

    // Ne pas afficher si on est déjà en train d'en montrer un
    if (_isAppOpenAdShowing) {
      if (onAdClosed != null) onAdClosed();
      return;
    }

    if (!_isAppOpenAdAvailable()) {
      print('⚠️ App Open Ad non disponible ou expiré. Rechargement...');
      if (onAdClosed != null) onAdClosed();
      _preloadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isAppOpenAdShowing = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('❌ App Open Ad failed to show: $error');
        _isAppOpenAdShowing = false;
        ad.dispose();
        _appOpenAd = null;
        if (onAdClosed != null) onAdClosed();
        _preloadAppOpenAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        print('✅ App Open Ad dismissed.');
        _isAppOpenAdShowing = false;
        ad.dispose();
        _appOpenAd = null;
        if (onAdClosed != null) onAdClosed();
        _preloadAppOpenAd(); // Recharge le prochain background
      },
    );

    _appOpenAd!.show();
  }
}
