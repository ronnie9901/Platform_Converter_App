import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_converter_app/converter/add_people_converter/ios.dart';
import 'package:platform_converter_app/converter/setting_converter/ios.dart';
import '../../provider/provider_homepage.dart';
import '../call_page_converter/ios.dart';
import '../chat_page_converter/ios.dart';

class HomePageIos extends StatelessWidget {
  const HomePageIos({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_add),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.phone),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const AddPeopleIos();
          case 1:
            return const ChatPageIos();
          case 2:
            return const CallPageIos();
          case 3:
            return const SettingPageIos();
          default:
            return Container();
        }
      },
    );
  }
}

CupertinoNavigationBar buildCupertinoNavigationBar(
    ProviderHomepage providerHomepageTrue,
    ProviderHomepage providerHomepageFalse) {
  return CupertinoNavigationBar(
    backgroundColor: Colors.transparent,
    trailing: CupertinoSwitch(
      value: providerHomepageTrue.isIos,
      onChanged: (value) {
        providerHomepageFalse.changePlatform();
      },
    ),
    middle: Text("Platform Converter",style: TextStyle(color: providerHomepageTrue.isDark ? Colors.white: null),),
  );
}
