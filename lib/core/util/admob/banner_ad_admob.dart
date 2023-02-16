import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdAdMob extends StatefulWidget {
  const BannerAdAdMob({super.key});

  @override
  State<BannerAdAdMob> createState() => _BannerAdAdMobState();
}

class _BannerAdAdMobState extends State<BannerAdAdMob> {
  late BannerAd bannerAd;
  late AdWidget adWidget;

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-8488117949492696/5266691395",
        listener: const BannerAdListener(),
        request: const AdRequest());
    bannerAd.load();
    adWidget = AdWidget(ad: bannerAd);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: adWidget,
    );
  }
}
