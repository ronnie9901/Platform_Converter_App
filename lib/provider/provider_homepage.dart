import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/db_helper.dart';
import '../model/contact_model.dart';

class ProviderHomepage extends ChangeNotifier{
  bool isIos = false,isDark = false,profileUpdate = false;
  File? profileImage,addPeopleImage,updatePeopleImage;
  String pickedDate = "",pickedTime = "",profileData = "";
  List<ContactModel> contactData = [];

  void changePlatform()
  {
    isIos = !isIos;
    notifyListeners();
  }

  void changeTheme(){
    isDark = !isDark;
    notifyListeners();
  }

  void isProfileUpdate()
  {
    profileUpdate = !profileUpdate;
    notifyListeners();
  }

  void getProfileImage(XFile? xFileImage) {
    if (xFileImage != null) {
      profileImage = File(xFileImage.path);
      notifyListeners();
    }
    else{
      profileImage = null;
      notifyListeners();
    }
  }

  void getAddPeopleImage(XFile? xFileImage) {
    if (xFileImage != null){
      addPeopleImage = File(xFileImage.path);
      notifyListeners();
    }
    else{
      addPeopleImage = null;
      notifyListeners();
    }
  }

  void getUpdatePeopleImage(XFile? xFileImage) {
    if (xFileImage != null){
      updatePeopleImage = File(xFileImage.path);
      notifyListeners();
    }
    else{
      updatePeopleImage = null;
      notifyListeners();
    }
  }

  void getDate(String date){
    pickedDate = date;
    notifyListeners();
  }

  void getTime(String time){
    pickedTime = time;
    notifyListeners();
  }

  Future<void> initializeDatabase() async {
    await DbHelper.dbHelper.initDb();
    getAllData();
  }

  Future<void> getAllData() async {
    List data = await DbHelper.dbHelper.getAllData();
    contactData = data.map((e) => ContactModel.fromMap(e),).toList();
    notifyListeners();
  }

  ProviderHomepage(){
    initializeDatabase();
    getProfile();
  }

  Future<void> insertData(String name,String phone,String chat,String img,String date,String time) async {
    await DbHelper.dbHelper.insertData(name, phone, chat, img, date, time);
    getAllData();
  }

  Future<void> deleteData(int id) async {
    await DbHelper.dbHelper.deleteData(id);
    getAllData();
  }

  void updateData(String name,String phone,String chat,String img,int id){
    DbHelper.dbHelper.updateData(name, phone, chat, img, id);
    getAllData();
  }

  Future<void> setProfile(String img,String name, String bio) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = "$img--$name--$bio";
    sharedPreferences.setString("profileData", data);
    getProfile();
  }

  Future<void> getProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    profileData = sharedPreferences.getString("profileData") ?? "";
    notifyListeners();
  }

}