import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdAdmob {
  static loadInterstitial({required Function(InterstitialAd) onAdLoaded}) {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-8488117949492696/6256942076',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            onAdLoaded(ad);
          },
          onAdFailedToLoad: (LoadAdError error) {},
        ));
  }
}
