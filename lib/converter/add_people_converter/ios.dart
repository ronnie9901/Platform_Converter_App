import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_converter_app/converter/add_people_converter/android.dart';
import 'package:provider/provider.dart';
import '../../provider/provider_homepage.dart';
import '../../utils/global.dart';
import '../homepage_converter/ios.dart';

class AddPeopleIos extends StatelessWidget {
  const AddPeopleIos({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderHomepage providerHomepageTrue =
    Provider.of<ProviderHomepage>(context, listen: true);
    ProviderHomepage providerHomepageFalse =
    Provider.of<ProviderHomepage>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: buildCupertinoNavigationBar(providerHomepageTrue, providerHomepageFalse),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
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
                buildCupertinoTextField("Full Name",txtFullName,CupertinoIcons.person,context),
                const Gap(14),
                buildCupertinoTextField("Phone Number",txtPhone,CupertinoIcons.phone,context),
                const Gap(14),
                buildCupertinoTextField("Chat Conversation",txtChat,CupertinoIcons.chat_bubble_2,context),
                const Gap(16),
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
                      buildCupertinoText(context, providerHomepageTrue.pickedDate.isEmpty
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
                      buildCupertinoText(context, providerHomepageTrue.pickedTime.isEmpty
                          ? "Pick Time"
                          : providerHomepageTrue.pickedTime)
                    ],
                  ),
                ),
                const Gap(30),
                CupertinoButton.filled(child: const Text("Save"), onPressed: () {
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
                ),
              ],
            ),
          ),
        ),
      ),
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
