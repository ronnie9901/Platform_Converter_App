import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_converter_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_homepage.dart';
import '../homepage_converter/ios.dart';

class CallPageIos extends StatelessWidget {
  const CallPageIos({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderHomepage providerHomepageTrue =
    Provider.of<ProviderHomepage>(context, listen: true);
    ProviderHomepage providerHomepageFalse =
    Provider.of<ProviderHomepage>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: buildCupertinoNavigationBar(providerHomepageTrue, providerHomepageFalse),
      child: ListView.builder(
        itemCount: providerHomepageTrue.contactData.length,
        itemBuilder: (context, index) {
          final data = providerHomepageTrue.contactData[index];
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: CupertinoListTile(
              title: buildCupertinoText(context, data.name),
              subtitle: buildCupertinoText(context, data.chat),
              leading: CircleAvatar(
                backgroundImage: FileImage(File(data.img)),
              ),
              trailing: const Icon(CupertinoIcons.phone,color: CupertinoColors.activeGreen,)
            ),
          );
        },
      ),
    );
  }
}
