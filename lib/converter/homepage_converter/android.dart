import 'package:flutter/material.dart';
import 'package:platform_converter_app/converter/add_people_converter/android.dart';
import 'package:provider/provider.dart';
import '../../provider/provider_homepage.dart';
import '../call_page_converter/android.dart';
import '../chat_page_converter/android.dart';
import '../setting_converter/android.dart';

class HomePageAndroid extends StatelessWidget {
  const HomePageAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderHomepage providerHomepageTrue =
        Provider.of<ProviderHomepage>(context, listen: true);
    ProviderHomepage providerHomepageFalse =
        Provider.of<ProviderHomepage>(context, listen: false);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Platform Converter'),
          backgroundColor: Colors.transparent,
          actions: [
            Switch(
              value: providerHomepageTrue.isIos,
              onChanged: (value) {
                providerHomepageFalse.changePlatform();
              },
            )
          ],
          bottom: const TabBar(
              tabAlignment: TabAlignment.fill,
              // labelStyle: TextStyle(
              //   fontWeight: FontWeight.bold,
              //   color: Colors.white,
              // ),
              // indicatorColor: Colors.blue,
              indicatorWeight: 2,
              // unselectedLabelStyle: TextStyle(
              //   fontWeight: FontWeight.normal,
              //   color: Colors.grey.shade700,
              // ),
              // unselectedLabelColor: Colors.grey.shade700,
              isScrollable: false,
              tabs: [
                Tab(child: Icon(Icons.person_add)),
                Tab(child: Text(' Chat ')),
                Tab(child: Text(' Calls ')),
                Tab(child: Text(' Settings ')),
              ]),
        ),
        body: const TabBarView(
          children: [
            AddPeopleAndroid(),
            ChatPageAndroid(),
            CallPageAndroid(),
            SettingPageAndroid()
          ],
        ),
      ),
    );
  }
}
