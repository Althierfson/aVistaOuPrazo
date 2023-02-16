import 'package:avistaouaprazo/environment.dart';
import 'package:avistaouaprazo/injection_container.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdAdmob {
  static loadInterstitial({required Function(InterstitialAd) onAdLoaded}) {
    InterstitialAd.load(
        adUnitId: sl<Environment>().interstitialAdmob,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            onAdLoaded(ad);
          },
          onAdFailedToLoad: (LoadAdError error) {},
        ));
  }
}
