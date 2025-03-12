import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:insta/main.dart';
import 'package:insta/screens/adds/appopen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  TextEditingController reelController = TextEditingController();
  late FToast fToast;
  bool isLogin = false;
  bool downloading = false;
  // ignore: unused_field
  bool _notificationsEnabled = false;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
     _loadBannerAd();
    _requestPermissions();
    fToast = FToast();
    fToast.init(context);
     WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () async => AppOpenAdManager().showAdIfAvailable(), ));
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-4585877554922388/9822908649', // Your ad unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdLoaded = true;  });  },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('BannerAd failed to load: $error');   },  ),  );
    _bannerAd!.load();
  }

Future<void> _requestPermissions() async {
       if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool? grantedNotificationPermission =
          await androidImplementation?.requestPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false; }); }
  }

@override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(FontAwesomeIcons.link, size: 15),
        SizedBox(
          width: 12.0,
        ),
        Text("url not found..!"
        ,style: TextStyle(color: Colors.red), ),  ], ),
  );

  void showToast(String msg,  Color color) {
   toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0), ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(FontAwesomeIcons.link, size: 15),
        const SizedBox(
          width: 12.0, ),
        Text(msg,style: TextStyle(color: color)), 
        ],  ), ); 
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2), );
}

  @override
  Widget build(BuildContext context) {
    print('homepage');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            downloading ? const CupertinoActivityIndicator() : Container(),
            Padding(
              padding: const EdgeInsets.all(20.0),
                 child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Image.asset('assets/images/image.png',
              width: 150,
              height: 150,),
                const SizedBox(height: 16),
                TextField(
                controller: reelController,
                decoration: const InputDecoration(
                 hintText: "Url",
                 hintStyle:  TextStyle(
                  color: Colors.grey,   ), ),
           style: const TextStyle(
                color: Color.fromARGB(255, 179, 196, 203),),  ), ], ),
            ),
            ElevatedButton(
              child: const Text('Download',),
              onPressed: () async {
                setState(() {
                  downloading = true;  });
                var connectivityResult = await Connectivity().checkConnectivity();// Check internet connectivity
                if (connectivityResult == ConnectivityResult.none) {
                  showToast("No internet connection", Colors.red);
                  setState(() {
                    downloading = false;  });
                  return; }
                var url = reelController.text.trim();
                if (url.isNotEmpty) {
                  final Uri uri = Uri.parse(url);
                  if (uri.hasAbsolutePath) {
                    downloadController.url(url);}
                     else {
                    print('else');}
                } else {
                  showToast("URL not found", Colors.red);}
                setState(() {
                  downloading = false;}); },
             ),
                TextButton(
                  onPressed: () async =>
                    {navigatorKey.currentState?.pushNamed('login')},
                       child: const Text('Login')),    
                    if (_isBannerAdLoaded && _bannerAd != null)
                     Container(
                     alignment: Alignment.center,
                      width: _bannerAd!.size.width.toDouble(),
                       height: _bannerAd!.size.height.toDouble(),
                     child: AdWidget(ad: _bannerAd!), ),
          ],
        ),
      ),
    );
  }
  showSnackBar(msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $msg'), ), );}
}
class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function() resumeCallBack;
  LifecycleEventHandler({required this.resumeCallBack});
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        resumeCallBack();
        break;
      default:
        break; } }}