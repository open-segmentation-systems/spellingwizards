import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

class AdManager {
  static MobileAdTargetingInfo get targetingInfo {
    return MobileAdTargetingInfo(
      keywords: <String>[
        'Education',
        'Dictionary',
        'Spelling',
        'Entertainment',
        'Language education',
        'Pronunciation'
      ],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      nonPersonalizedAds: true,
      testDevices: <String>[], // Android emulators are considered test devices
    );
  }

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6511520637337939~1250925774";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_ADMOB_APP_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6511520637337939/8739367708";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6511520637337939/2787029410";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6511520637337939/9679261892";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
