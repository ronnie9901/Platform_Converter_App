import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../provider/provider_homepage.dart';
import '../../utils/global.dart';
import '../homepage_converter/ios.dart';
import 'android.dart';

class SettingPageIos extends StatelessWidget {
  const SettingPageIos({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderHomepage providerHomepageTrue =
    Provider.of<ProviderHomepage>(context, listen: true);
    ProviderHomepage providerHomepageFalse =
    Provider.of<ProviderHomepage>(context, listen: false);
    List<String> profileParts = providerHomepageTrue.profileData.split('--');
    print("--------------------> $profileParts");
    String? img;
    if(profileParts.length >= 3){
      img = profileParts[0];
      txtName.text = profileParts[1];
      txtBio.text = profileParts[2];
    }
    else{
      img = "";
    }
    return CupertinoPageScaffold(
      navigationBar: buildCupertinoNavigationBar(providerHomepageTrue, providerHomepageFalse),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(15),
              CupertinoListTile(
                leading: const Icon(CupertinoIcons.person),
                title:  buildCupertinoText(context,"Profile"),
                subtitle: buildCupertinoText(context, "Update Profile Data"),
                trailing: CupertinoSwitch(value: providerHomepageTrue.profileUpdate, onChanged: (value){
                  providerHomepageFalse.isProfileUpdate();
                }),
              ),
              const Gap(20),
              if (providerHomepageTrue.profileUpdate) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const Gap(14),
                    GestureDetector(
                      onTap: () async {
                        XFile? xFileImage = await ImagePicker().pickImage(source: ImageSource.camera);
                        providerHomepageFalse.getProfileImage(xFileImage!);
                      },
                      child: CircleAvatar(
                          backgroundImage: providerHomepageTrue.profileImage == null ? FileImage(File(img)) : FileImage(providerHomepageTrue.profileImage!),
                          radius: 55,
                          child: providerHomepageTrue.profileImage == null && img.isEmpty ? const Icon(
                            Icons.add_a_photo_outlined,
                            size: 25,
                          ) : null
                      ),
                    ),
                    const Gap(15),
                    buildCupertinoTextField("Enter Your Name",txtName,context),
                    const Gap(14),
                    buildCupertinoTextField("Enter Your Bio..",txtBio,context),
                    const Gap(14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(onPressed: (){}, child: const Text("Save")),
                        CupertinoButton(onPressed: (){
                          providerHomepageTrue.getProfileImage(null);
                          txtBio.clear();
                          txtName.clear();
                        }, child: const Text("Clear")),
                      ],
                    ),
                    const Gap(20),
                  ],
                ),
              ) else const SizedBox(),
              CupertinoListTile(
                leading: const Icon(CupertinoIcons.sun_min),
                title:  buildCupertinoText(context,"Theme"),
                subtitle: buildCupertinoText(context, "Change Theme"),
                trailing: CupertinoSwitch(value: providerHomepageTrue.isDark, onChanged: (value){
                  providerHomepageFalse.changeTheme();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CupertinoTextField buildCupertinoTextField(String hintText,TextEditingController controller,BuildContext context) {
    final isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;
    return CupertinoTextField(
      controller: controller,
      textAlign: TextAlign.center,
      placeholder: hintText,
      placeholderStyle: const TextStyle(
          color: Colors.grey
      ),
      style: TextStyle(
        color: isDarkMode ? CupertinoColors.white : CupertinoColors.black, // Adjust text color based on mode
      ),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemGrey6,
        border: Border(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // style: CupertinoTheme.of(context).textTheme.textStyle,
    );
  }
}