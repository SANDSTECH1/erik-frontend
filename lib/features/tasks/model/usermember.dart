class getMembersModel {
  bool? success;
  String? message;
  List<userListData>? data;

  getMembersModel({this.success, this.message, this.data});

  getMembersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <userListData>[];
      json['data'].forEach((v) {
        data!.add(new userListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class userListData {
  String? sId;
  String? name;
  String? email;
  String? password;
  String? image;
  bool? otpVerified;
  bool selected = false;

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
    selected = false;
    tasks = json['tasks'].cast<String>();
    subtasks = json['subtasks'].cast<String>();
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['selected'] = this.selected;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['image'] = this.image;
    data['otpVerified'] = this.otpVerified;
    data['tasks'] = this.tasks;
    data['subtasks'] = this.subtasks;
    data['__v'] = this.iV;
    return data;
  }
}
