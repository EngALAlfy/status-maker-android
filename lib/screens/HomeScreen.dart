import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';
import 'package:status_maker/pages/MakerPage.dart';
import 'package:status_maker/pages/SavedPage.dart';
import 'package:status_maker/pages/WhatsAppBusinessPage.dart';
import 'package:status_maker/pages/WhatsAppPage.dart';
import 'package:status_maker/providers/UtilsProvider.dart';

class HomeScreen extends StatelessWidget {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 1);
  final ValueNotifier appBarTitle = ValueNotifier<String>("صانع الحالات");
  final ValueNotifier appBarIcon =
      ValueNotifier<IconData>(Icons.color_lens_outlined);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 60),
              child: ListTile(
                title: Text(
                  "#صانع الحالات",
                  style: TextStyle(fontSize: 30),
                ),
                subtitle: Text(
                  "زخرف حالاتك بسهولة",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Divider(),
                  ListTile(
                    onTap: () async {
                      if (await InAppReview.instance.isAvailable()) {
                        await InAppReview.instance.requestReview();
                      } else {
                        await InAppReview.instance.openStoreListing();
                      }
                    },
                    title: Text(
                      "تقييم",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    leading: Icon(Icons.star_border_outlined),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      SocialShare.shareOptions(
                          " استمتع وشارك اجمل الرسايل  والبوستات الحزينه وحالات الحب والغرام مع تطبيق بوستاتي https://play.google.com/store/apps/details?id=com.alalfy.status_maker \n");
                    },
                    title: Text(
                      "مشاركة",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    leading: Icon(Icons.share),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      SystemNavigator.pop(animated: true);
                    },
                    title: Text(
                      "خروج",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    leading: Icon(Icons.logout),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: ValueListenableBuilder(
          valueListenable: appBarIcon,
          builder: (context, value, child) => Icon(value),
        ),
        title: ValueListenableBuilder(
          valueListenable: appBarTitle,
          builder: (context, value, child) => Text(value),
        ),
        centerTitle: true,
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        // This needs to be true if you want to move up the screen when keyboard appears.
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
        decoration: NavBarDecoration(
            border: Border(
                top: BorderSide(
                    style: BorderStyle.solid, width: 1, color: Colors.grey))),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1,
        onItemSelected: (value) {
          switch (value) {
            case 1:
              appBarTitle.value = "صانع الحالات";
              appBarIcon.value = Icons.color_lens_outlined;
              break;
            case 0:
              appBarTitle.value = "حالات اصدقاء الواتس اب";
              appBarIcon.value = FlutterIcons.whatsapp_faw;
              break;
            case 2:
              appBarTitle.value = "حالات اصدقاء واتس اب للاعمال";
              appBarIcon.value = FlutterIcons.whatsapp_faw;
              break;
            case 3:
              appBarTitle.value = "الحالات المحفوظة";
              appBarIcon.value = FlutterIcons.save_ant;
              break;
          }
        }, // Choose the nav bar style with this property.
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(FlutterIcons.whatsapp_faw),
        title: "الواتساب",
        activeColor: Colors.green,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.color_lens_outlined),
        title: "اصنع",
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          AssetImage("assets/images/whatsappbiz.png"),
          size: 30,
        ),
        title: "واتساب اعمال",
        activeColor: Colors.greenAccent,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FlutterIcons.save_ant),
        title: "المحفوظة",
        activeColor: Colors.redAccent,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      WhatsAppPage(),
      MakerPage(),
      WhatsAppBusinessPage(),
      SavedPage(),
    ];
  }
}
