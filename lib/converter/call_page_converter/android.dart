import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_homepage.dart';

class CallPageAndroid extends StatelessWidget {
  const CallPageAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderHomepage providerHomepageTrue =
    Provider.of<ProviderHomepage>(context, listen: true);
    ProviderHomepage providerHomepageFalse =
    Provider.of<ProviderHomepage>(context, listen: false);
    return Scaffold(
      body: ListView.builder(
        itemCount: providerHomepageTrue.contactData.length,
        itemBuilder: (context, index) {
          final data = providerHomepageTrue.contactData[index];
          return ListTile(
            title: Text(data.name),
            subtitle: Text(data.chat),
            leading: CircleAvatar(backgroundImage: FileImage(File(data.img),),),
            trailing: const Icon(Icons.call,color: Colors.green,)
          );
        },
      ),
    );
  }
}
