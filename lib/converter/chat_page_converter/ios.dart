import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_converter_app/model/contact_model.dart';
import 'package:platform_converter_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_homepage.dart';
import '../add_people_converter/android.dart';
import '../homepage_converter/ios.dart';

class ChatPageIos extends StatelessWidget {
  const ChatPageIos({super.key});

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
              onTap: () {
                buildShowCupertinoModalBottomSheet(context, data, providerHomepageFalse,providerHomepageTrue,);
              },
              title: buildCupertinoText(context, data.name),
              subtitle: buildCupertinoText(context, data.chat),
              leading: CircleAvatar(
                backgroundImage: FileImage(File(data.img)),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildCupertinoText(context, "${data.date} "),
                  buildCupertinoText(context, data.time),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> buildShowCupertinoModalBottomSheet(
      BuildContext context, ContactModel data, ProviderHomepage providerHomepageFalse,ProviderHomepage providerHomepageTrue) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundImage: FileImage(File(data.img)),
              ),
              const Gap(12),
              Text(
                data.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(data.chat),
            ],
          ),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                txtFullName.text = data.name;
                txtPhone.text = data.phone;
                txtChat.text = data.chat;
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text("User Details"),
                      content: Column(
                        children: [
                          const Gap(15),
                          GestureDetector(
                            onTap: () async {
                              XFile? xFileImage = await ImagePicker().pickImage(source: ImageSource.camera);
                              providerHomepageFalse.getUpdatePeopleImage(xFileImage);
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: providerHomepageTrue.updatePeopleImage == null
                                  ? FileImage(File(data.img))
                                  : FileImage(providerHomepageTrue.updatePeopleImage!),
                            ),
                          ),
                          const Gap(12),
                          buildCupertinoTextField("Name", txtFullName, CupertinoIcons.person, context),
                          const Gap(12),
                          buildCupertinoTextField("Phone", txtPhone, CupertinoIcons.phone, context),
                          const Gap(12),
                          buildCupertinoTextField("Chat", txtChat, CupertinoIcons.chat_bubble, context)
                        ],
                      ),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () {
                            String img = providerHomepageTrue.updatePeopleImage == null
                                ? data.img
                                : providerHomepageTrue.updatePeopleImage!.path.toString();
                            providerHomepageFalse.updateData(txtFullName.text, txtPhone.text, txtChat.text, img, data.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            txtFullName.clear();
                            txtPhone.clear();
                            txtChat.clear();
                            providerHomepageFalse.getUpdatePeopleImage(null);
                          },
                          child: const Text("Ok"),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context);
                            providerHomepageFalse.getUpdatePeopleImage(null);
                          },
                          isDestructiveAction: true,
                          child: const Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Edit"),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                providerHomepageFalse.deleteData(data.id);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        );
      },
    );
  }
  CupertinoTextField buildCupertinoTextField(String hintText,TextEditingController controller, IconData icon,BuildContext context) {
    final isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;
    return CupertinoTextField(
      controller: controller,
      placeholder: hintText,
      placeholderStyle: const TextStyle(
          color: Colors.grey
      ),
      style: TextStyle(
        color: isDarkMode ? CupertinoColors.white : CupertinoColors.black, // Adjust text color based on mode
      ),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Icon(icon, color: CupertinoColors.systemGrey),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
