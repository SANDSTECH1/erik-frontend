import 'package:erick/features/subtasks/viewmodel/selectedmebersviewmodel.dart';

class userListData {
  String? sId;
  String? name;
  String? email;
  String? password;
  String? image;
  bool? otpVerified;
  bool selected = false;
  String? estimatedTime;
  String? price;

  List<String>? tasks;
  List<String>? subtasks;
  int? iV;

  userListData(
      {this.sId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.otpVerified,
      this.tasks,
      this.estimatedTime,
      this.price,
      required this.selected,
      this.subtasks,
      this.iV});

  userListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
    otpVerified = json['otpVerified'];
    estimatedTime = json['estimatedTime'];
    price = json['price'];
    selected = false;
    tasks = json['tasks'].cast<String>();
    subtasks = json['subtasks'].cast<String>();
    iV = json['__v'];
    // Add a method to toggle selected state
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['selected'] = selected;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['image'] = image;
    data['otpVerified'] = otpVerified;
    data['estimatedTime'] = estimatedTime;
    data['price'] = price;
    data['tasks'] = tasks;
    data['subtasks'] = subtasks;
    data['__v'] = iV;
    return data;
  }
}
