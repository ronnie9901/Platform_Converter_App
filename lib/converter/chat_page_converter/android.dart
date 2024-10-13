import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_converter_app/converter/add_people_converter/android.dart';
import 'package:platform_converter_app/model/contact_model.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_homepage.dart';

class ChatPageAndroid extends StatelessWidget {
  const ChatPageAndroid({super.key});

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
            onTap: (){
              buildShowModalBottomSheet(context, data, providerHomepageFalse,providerHomepageTrue);
            },
            title: Text(data.name),
            subtitle: Text(data.chat),
            leading: CircleAvatar(backgroundImage: FileImage(File(data.img),),),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${data.date} "),
                Text(data.time),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context,
      ContactModel data, ProviderHomepage providerHomepageFalse, ProviderHomepage providerHomepageTrue) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const Gap(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {
                    txtFullName.text = data.name;
                    txtPhone.text = data.phone;
                    txtChat.text = data.chat;
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text("User Details"),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  XFile? xFileImage =
                                  await ImagePicker().pickImage(source: ImageSource.camera);
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
                              buildTextField("Name", txtFullName, Icons.person),
                              const Gap(12),
                              buildTextField("Phone", txtPhone, Icons.phone),
                              const Gap(12),
                              buildTextField("Chat", txtChat, Icons.chat),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: () {
                            String img = providerHomepageTrue.updatePeopleImage == null ? data.img : providerHomepageTrue.updatePeopleImage!.path.toString();
                            providerHomepageFalse.updateData(txtFullName.text, txtPhone.text, txtChat.text, img, data.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            txtFullName.clear();
                            txtPhone.clear();
                            txtChat.clear();
                            providerHomepageFalse.getUpdatePeopleImage(null);
                          }, child: const Text("Ok")),
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                            providerHomepageFalse.getUpdatePeopleImage(null);
                          }, child: const Text("Cancel")),
                        ],
                      );
                    },);
                  }, icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        providerHomepageFalse.deleteData(data.id);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"))
            ],
          ),
        );
      },
    );
  }

  TextField buildTextField(String labelText, TextEditingController controller, IconData icon,{TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
