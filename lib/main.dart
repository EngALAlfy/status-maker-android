
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:status_maker/providers/AdsProvider.dart';
import 'package:status_maker/providers/DatabaseProvider.dart';
import 'package:status_maker/providers/MakerProvider.dart';
import 'package:status_maker/providers/NotificationsProvider.dart';
import 'package:status_maker/providers/StatusProvider.dart';
import 'package:status_maker/providers/UtilsProvider.dart';
import 'package:status_maker/screens/HomeScreen.dart';
import 'package:status_maker/screens/IntroScreen.dart';
import 'package:status_maker/utils/Config.dart';
import 'package:status_maker/widgets/IsErrorWidget.dart';
import 'package:status_maker/widgets/IsLoadingWidget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationsProvider(context)),
        ChangeNotifierProvider(create: (context) => UtilsProvider()),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),

        ChangeNotifierProvider(create: (context) => MakerProvider()),
        ChangeNotifierProvider(create: (context) => StatusProvider()),

        ChangeNotifierProvider(create: (context) => AdsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('ar', ''),
        ],
        theme: ThemeData(
          fontFamily: "hor",
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Config.PRIMARY_COLOR,
          accentColor: Config.ACCENT_COLOR,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: EasyLoading.init(),
        home: Consumer2<UtilsProvider , NotificationsProvider>(
          builder: (context, utils , notifications , child) {
            return WillPopScope(
              child: getScreen(utils, child),
              onWillPop: () async {
                if (
                !utils.isReviewed && !utils.noInternet) {
                  rateDialog(context , utils);
                } else {
                  exitDialog(context);
                }
                return false;
              },
            );
          },
          child: IsLoadingWidget(),
        ),
      ),
    );
  }

  getScreen(UtilsProvider utils, child) {
    if (utils.isLoaded) {
      if (utils.isFirstOpen) {
        return IntroScreen();
      } else {

        if (utils.noInternet) {
          return IsErrorWidget(error: "لا يوجد انترنت",);
        }

        return HomeScreen();
      }
    }

    return child;
  }

  void exitDialog(context) {
    Alert(context: context, title: "هل تريد الخروج ؟", buttons: [
      DialogButton(
          color: Colors.red,
          child: Text(
            "خروج",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            SystemNavigator.pop();
          }),
      DialogButton(
          color: Colors.blue,
          child: Text(
            "لا",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context, false);
          }),
    ]).show();
  }

  rateDialog(BuildContext context , utils) {
    Alert(
        context: context,
        type: AlertType.success,
        title: "تقييم",
        desc: "هل اعجبك تطبيقنا ؟ تقييم الان ..!",
        buttons: [
          DialogButton(
              child: Text(
                "تقييم",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
              color: Colors.green,
              onPressed: () async {
                if (await InAppReview.instance.isAvailable()) {
                  await InAppReview.instance.requestReview();
                } else {
                  await InAppReview.instance.openStoreListing();
                }
                await utils.setReviewed();
                Navigator.pop(context);
              }),
          DialogButton(
              child: Text(
                "لا",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
              color: Colors.red,
              onPressed: () async {
                await utils.setReviewed();
                Navigator.pop(context);
              }),
          DialogButton(
              child: Text(
                "لاحقا",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
              color: Colors.black,
              onPressed: () {
                SystemNavigator.pop(animated: true);
              }),
        ]).show();
  }
}
