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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['selected'] = selected;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['image'] = image;
    data['otpVerified'] = otpVerified;
    data['tasks'] = tasks;
    data['subtasks'] = subtasks;
    data['__v'] = iV;
    return data;
  }
}
