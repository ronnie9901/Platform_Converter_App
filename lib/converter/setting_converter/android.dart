import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_homepage.dart';

TextEditingController txtName = TextEditingController();
TextEditingController txtBio = TextEditingController();

class SettingPageAndroid extends StatelessWidget {
  const SettingPageAndroid({super.key});

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              subtitle: const Text("Update Profile Data"),
              trailing: Switch(value: providerHomepageTrue.profileUpdate, onChanged: (value) {
                providerHomepageFalse.isProfileUpdate();
              },),
            ),
            const Gap(5),
            if (providerHomepageTrue.profileUpdate) Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          XFile? xFileImage = await ImagePicker().pickImage(source: ImageSource.camera);
                          providerHomepageFalse.getProfileImage(xFileImage!);
                        },
                        child: CircleAvatar(
                          backgroundImage: providerHomepageTrue.profileImage == null ? FileImage(File(img)): FileImage(providerHomepageTrue.profileImage!),
                          radius: 55,
                          child: providerHomepageTrue.profileImage == null && img.isEmpty ? const Icon(
                            Icons.add_a_photo_outlined,
                            size: 25,
                          ) : null
                        ),
                      ),
                      const Gap(7),
                      buildTextField("Enter Your Name..",txtName),
                      buildTextField("Enter Your Bio..",txtBio),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(onPressed: (){
                            providerHomepageFalse.setProfile(providerHomepageTrue.profileImage != null ? providerHomepageTrue.profileImage!.path.toString() : img! , txtName.text, txtBio.text);
                          }, child: const Text("Save")),
                          TextButton(onPressed: (){
                              providerHomepageTrue.getProfileImage(null);
                              txtBio.clear();
                              txtName.clear();
                              providerHomepageFalse.setProfile("", "", "");
                            }, child: const Text("Clear")),
                        ],
                      ),
                    ],
                  ) else const SizedBox(),
            const Divider(indent: 15,endIndent: 15),
            ListTile(
              leading: const Icon(Icons.light_mode_outlined),
              title: const Text("Theme"),
              subtitle: const Text("Change Theme"),
              trailing: Switch(value: providerHomepageTrue.isDark, onChanged: (value) {
                providerHomepageFalse.changeTheme();
              },),
            ),
          ],
        ),
      ),
    );
  }
}

TextField buildTextField(String hintText,TextEditingController controller) {
  return TextField(
    controller: controller,
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      hintText: hintText,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    ),
  );
}
