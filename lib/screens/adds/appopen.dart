import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  static final AppOpenAdManager _singleton = AppOpenAdManager._internal();
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  bool _isAdLoaded = false;

  factory AppOpenAdManager() {
    return _singleton;
  }

  AppOpenAdManager._internal();

  void loadAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-4585877554922388/9255431428',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('AppOpenAd loaded');
          _appOpenAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          _isAdLoaded = false;
          // Optionally, retry loading after some delay
          Future.delayed(const Duration(seconds: 30), loadAd);
        },
      ),
    );
  }

  void showAdIfAvailable() {
    if (_isShowingAd) {
      print('Ad is already showing');
      return;
    }

    if (!_isAdLoaded) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }

    if (_appOpenAd == null) {
      print('Ad reference is null.');
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (AppOpenAd ad) {
        _isShowingAd = true;
        print('Ad showed.');
      },
      onAdDismissedFullScreenContent: (AppOpenAd ad) {
        _isShowingAd = false;
        print('Ad dismissed.');
        ad.dispose();
        _appOpenAd = null;
        _isAdLoaded = false;
        loadAd(); // Reload the ad after dismissal
      },
      onAdFailedToShowFullScreenContent: (AppOpenAd ad, AdError error) {
        _isShowingAd = false;
        print('Ad failed to show: $error');
        ad.dispose();
        _appOpenAd = null;
        _isAdLoaded = false;
        loadAd(); // Reload the ad after failure
      },
    );

    _appOpenAd!.show();
    _appOpenAd = null;
    _isAdLoaded = false;
  }
}