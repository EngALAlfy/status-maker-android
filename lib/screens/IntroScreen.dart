import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:status_maker/providers/UtilsProvider.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        pages: [
          PageViewModel(
            titleWidget: Text(
              "صانع الحالات",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "رسايل وبوستات حالات واقتباسات",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
            ),
            image: Image.asset("assets/images/logo.png"),
            footer: Text(
              "اصنع حالاتك وبوستاتك باسهل طريقة",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 40),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 50),
            ),
          ),

          PageViewModel(
            titleWidget: Text(
              "صانع الحالات",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "رسايل وبوستات حالات واقتباسات",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
            ),
            footer: Text(
              "استمتع باجمل وافضل الخطوط والزخارف لحالاتك",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 40),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 50),
            ),
            image: Image.asset("assets/images/premium.png"),
          ),

          PageViewModel(
            titleWidget: Text(
              "صانع الحالات",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "رسايل وبوستات حالات واقتباسات",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
            ),
            footer: Text(
              "تحكم في شكل ولون الخط والخلفيه واحفظها وشاركها",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 40),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 50),
            ),
            image: Icon(Icons.color_lens_outlined , size: 230,),
          ),

          PageViewModel(
            titleWidget: Text(
              "صانع الحالات",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "رسايل وبوستات حالات واقتباسات",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
            ),
            footer: Text(
              "يمكنك  زخرفة الحالات وحفظ الحالات كصورة او مشاركتها علي السوشيال",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 40),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 50),
            ),
            image: Icon(Icons.font_download_outlined , size: 230,),
          ),

          PageViewModel(
            titleWidget: Text(
              "صانع الحالات",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "رسايل وبوستات حالات واقتباسات",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
            ),
            footer: Text(
              "يمكنك حفظ الحالات وتصفحها فيما بعد بدون انترنت من المحفوظاات",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 40),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 50),
            ),
            image: Icon(FontAwesome.save , size: 230,),
          ),

          PageViewModel(
            titleWidget: Text(
              "صانع الحالات",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "رسايل وبوستات حالات واقتباسات",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
            ),
            footer: Text(
              "يجب منح الصلاحيات للتطبيق ليعمل بشكل سليم",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 40),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 50),
            ),
            image: Icon(FontAwesome.shield , size: 230,),
          ),
        ],
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Theme.of(context).accentColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            )
        ),
        next: Icon(Icons.arrow_forward_ios),
        onDone: () async {
          UtilsProvider utilsProvider =
              Provider.of<UtilsProvider>(context, listen: false);

          await utilsProvider.checkPermissions();

          await utilsProvider.setFirstOpen();
        },
        done: Text(
          "فهمت",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
        ));
  }
}
