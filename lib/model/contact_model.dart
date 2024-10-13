class ContactModel {
  late String img, name, phone, chat, time, date;
  late int id;

  ContactModel(
      {required this.id,
      required this.img,
      required this.name,
      required this.phone,
      required this.chat,
      required this.time,
      required this.date});

  factory ContactModel.fromMap(Map m1) {
    return ContactModel(
        id: m1["id"],
        img: m1["img"],
        name: m1["name"],
        phone: m1["phone"],
        chat: m1["chat"],
        time: m1["time"],
        date: m1["date"]);
  }
}
