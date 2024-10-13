import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_homepage.dart';

TextEditingController txtFullName = TextEditingController();
TextEditingController txtPhone = TextEditingController();
TextEditingController txtChat = TextEditingController();

class AddPeopleAndroid extends StatelessWidget {
  const AddPeopleAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderHomepage providerHomepageTrue =
        Provider.of<ProviderHomepage>(context, listen: true);
    ProviderHomepage providerHomepageFalse =
        Provider.of<ProviderHomepage>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(20),
            GestureDetector(
              onTap: () async {
                XFile? xFileImage =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                providerHomepageFalse.getAddPeopleImage(xFileImage);
              },
              child: CircleAvatar(
                  backgroundImage: providerHomepageTrue.addPeopleImage == null
                      ? null
                      : FileImage(providerHomepageTrue.addPeopleImage!),
                  radius: 55,
                  child: providerHomepageTrue.addPeopleImage == null
                      ? const Icon(
                          Icons.add_a_photo_outlined,
                          size: 25,
                        )
                      : null),
            ),
            const Gap(28),
            buildTextField("Full Name", txtFullName,Icons.person_outline),
            const Gap(12),
            buildTextField("Phone Number", txtPhone,Icons.phone,keyboardType: TextInputType.phone),
            const Gap(12),
            buildTextField("Chat Conversation", txtChat,Icons.chat),
            const Gap(13),
            GestureDetector(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  providerHomepageFalse.getDate('${date.day}/${date.month}/${date.year}');
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const Gap(6),
                  Text(providerHomepageTrue.pickedDate.isEmpty
                      ? "Pick Date"
                      : providerHomepageTrue.pickedDate)
                ],
              ),
            ),
            const Gap(13),
            GestureDetector(
              onTap: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  final formattedTime = time.format(context);
                  providerHomepageFalse.getTime(formattedTime);
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded),
                  const Gap(6),
                  Text(providerHomepageTrue.pickedTime.isEmpty
                        ? "Pick Time"
                        : providerHomepageTrue.pickedTime,
                  ),
                ],
              ),
            ),
            const Gap(13),
            OutlinedButton(
                onPressed: () {
                  String img = providerHomepageTrue.addPeopleImage!.path.toString();
                  providerHomepageFalse.insertData(
                      txtFullName.text,
                      txtPhone.text,
                      txtChat.text,
                      img,
                      providerHomepageTrue.pickedDate,
                      providerHomepageTrue.pickedTime);
                  txtFullName.clear();
                  txtPhone.clear();
                  txtChat.clear();
                  providerHomepageFalse.getDate("");
                  providerHomepageFalse.getTime("");
                  providerHomepageFalse.getAddPeopleImage(null);
                },
                child: const Text("Save"))
          ],
        ),
      ),
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

//image: FileImage(File(controller.data[index]['img'])),),