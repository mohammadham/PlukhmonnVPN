import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
const String testDevice = '0b60a0dc8901ca7b635b7294ef48b01a';
const int maxFailedLoadAttempts = 3;


class AdmobHelper {
  static final AdmobHelper _instance = AdmobHelper._internal();

  factory AdmobHelper() {
    return _instance;
  }

  AdmobHelper._internal();

  static const Map<String, Map<TargetPlatform, String>> _adUnitIds = {
    'banner': {
      TargetPlatform.android: 'ca-app-pub-3940256099942544/6300978111',
      TargetPlatform.iOS: 'ca-app-pub-3940256099942544/2934735716',
    },
    'interstitial': {
      TargetPlatform.android: 'ca-app-pub-3940256099942544/1033173712',
      TargetPlatform.iOS: 'ca-app-pub-3940256099942544/4411468910',
    },
    'rewarded': {
      TargetPlatform.android: 'ca-app-pub-3940256099942544/5224354917',
      TargetPlatform.iOS: 'ca-app-pub-3940256099942544/1712485313',
    },
  };

  static String _getAdUnitId(String adType) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _adUnitIds[adType]?[TargetPlatform.android] ?? '';
      case TargetPlatform.iOS:
        return _adUnitIds[adType]?[TargetPlatform.iOS] ?? '';
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }



  static String get bannerAdUnitId => _getAdUnitId('banner');
  static String get interstitialAdUnitId => _getAdUnitId('interstitial');
  static String get rewardedAdUnitId => _getAdUnitId('rewarded');

  static BannerAd? _bannerAd;
  static List<BannerAd> _bannerAds = [];
  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  static RewardedAd? _rewardedAd;
  static int _numRewardedLoadAttempts = 0;

  static RewardedInterstitialAd? _rewardedInterstitialAd;
  static int _numRewardedInterstitialLoadAttempts = 0;

  static BannerAd? get bannerAd => _bannerAd;
  static List<BannerAd> get bannerAds => _bannerAds;


  static initialize() {
    if (MobileAds.instance == null) {
      print("initialize:AdMob");
      MobileAds.instance.initialize();
    }
  }



  static BannerAd createBannerAd() {
  BannerAd ad = new BannerAd(
    adUnitId: _getAdUnitId('banner'),
    size: AdSize.largeBanner,
    request: AdRequest(),
    //listener: null,
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print('Ad failed to load: $error');
        ad.dispose();
      },
      onAdOpened: (Ad ad) => print('Ad opened.'),
      onAdClosed: (Ad ad) => print('Ad closed.'),
    ),
  );

  return ad;
  }
  static void showBannerAds(int index) {
    if (! _bannerAds.isEmpty && index >= 0 && index < _bannerAds.length && _bannerAds[index]!=null ) {
      if (_bannerAds[index] != null) {
        _bannerAds[index]?.load();
      }
      return;
    }
    _bannerAds.add( createBannerAd());
    if (_bannerAds[_bannerAds.length-1] != null) {
      _bannerAds[_bannerAds.length-1]!.load();
    }
  }
  static void removeBannerAd(int index) {
    if (index >= 0 && index < _bannerAds.length) {
      _bannerAds[index].dispose();
      _bannerAds.removeAt(index);
    }
  }
  static void showBannerAd() {
  if (_bannerAd != null) {
  return;
  }
  _bannerAd = createBannerAd();
  if (_bannerAd != null) {
    _bannerAd!.load();
  }
  }

  void disposeAds() {
    print("disposeAds");
    if (_bannerAd != null) {
      _bannerAd?.dispose();
    }
    if (_interstitialAd != null) {
      _interstitialAd?.dispose();
    }
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    if(_bannerAds.length>0){
    for(int i =_bannerAds.length-1 ;i>=0;i=i+1){
      removeBannerAd(i);
    }}
    _bannerAd = null;
    _interstitialAd = null;
    _rewardedAd= null;
    _rewardedInterstitialAd= null;
  }

  static _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _getAdUnitId('interstitial'),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;

          // _interstitialAd!.show();
          // _interstitialAd = null;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }
  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      _createInterstitialAd();
    } else {
      _showInterstitialAd();
    }
  }

  static void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  static void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: _getAdUnitId('rewarded'),
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }
  static void showRewardedAd() {
    if (_rewardedAd == null) {
      _createRewardedAd();
    } else {
      _showRewardedAd();
    }
  }
  static void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedAd = null;
  }

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: _getAdUnitId('rewarded'),
        request: AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
              print('$ad onAdShowedFullScreenContent.'),
          onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
            print('$ad onAdDismissedFullScreenContent.');
            ad.dispose();
            _createRewardedInterstitialAd();
          },
          onAdFailedToShowFullScreenContent:
              (RewardedInterstitialAd ad, AdError error) {
            print('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            _createRewardedInterstitialAd();
          },
        );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedInterstitialAd = null;
  }

}

