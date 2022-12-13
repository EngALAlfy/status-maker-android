import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:status_maker/providers/StatusProvider.dart';
import 'package:status_maker/widgets/IsErrorWidget.dart';
import 'package:status_maker/widgets/IsLoadingWidget.dart';
import 'package:status_maker/widgets/StatusPageView.dart';
import 'package:status_maker/widgets/StatusWidget.dart';

class WhatsAppBusinessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StatusProvider provider =
        Provider.of<StatusProvider>(context, listen: false);
    provider.checkWhatsAppBizFolder();

    return Scaffold(
      body: Consumer<StatusProvider>(
        builder: (context, value, child) {
          var list = value.statusBizList;

          if(value.isError){
            return IsErrorWidget(error: value.error,);
          }

          if (list == null) {
            return IsLoadingWidget();
          }

          return StatusPageView(
              storiesMapList: [
                StoryItem(
                  stories: List.generate(list.length + 1, (index) {
                    if (index == 1) {
                      return StatusWidget(
                        isAd: true,
                      );
                    }

                    var status = list.elementAt(index == 0 ? index : index - 1);

                    return StatusWidget(
                      file: status,
                    );
                  }),
                ),
              ],
              storyChanged: (index) {
                print(index);
              },
              storyNumber: 0);
        },
      ),
    );
  }
}
