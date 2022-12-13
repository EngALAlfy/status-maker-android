import 'package:admob_flutter/admob_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:status_maker/utils/Config.dart';

class AdsProvider extends ChangeNotifier {
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  bool noInternet = false;

  AdsProvider() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        noInternet = true;
      } else {
        noInternet = false;
      }
      notifyListeners();
    });
  }

  getFullScreen() {
    interstitialAd = AdmobInterstitial(
      adUnitId: Config.AD_FULL_ID,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, (){}, interstitialAd);
      },
    );

    interstitialAd.load();
  }

  getReward() {
    rewardAd = AdmobReward(
      adUnitId: Config.AD_REWARD_ID,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, (){}, rewardAd);
      },
    );

    rewardAd.load();
  }

  void handleEvent(AdmobAdEvent event, callback, ad) {
    switch (event) {
      case AdmobAdEvent.loaded:
        ad.show();
        break;
      case AdmobAdEvent.closed:
      case AdmobAdEvent.failedToLoad:
      case AdmobAdEvent.rewarded:
        callback();
        break;
      default:
    }
  }

  Widget getBanner({size: AdmobBannerSize.BANNER}) {
    return AdmobBanner(
      adUnitId: Config.AD_BANNER_ID,
      adSize: size,
    );
  }
}
