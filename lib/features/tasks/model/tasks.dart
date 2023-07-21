class createTaskModel {
  bool? success;
  String? message;
  Data? data;

  createTaskModel({this.success, this.message, this.data});

  createTaskModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? title;
  String? description;
  List<String>? assignedUsers;
  String? subTasks;
  String? createdBy;

  String? scheduledDateTime;
  String? sId;
  int? iV;

  Data(
      {this.title,
      this.description,
      this.assignedUsers,
      this.subTasks,
      this.createdBy,
      this.scheduledDateTime,
      this.sId,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    assignedUsers = json['assignedUsers'].cast<String>();
    subTasks = json['subTasks'];
    createdBy = json['createdBy'];

    scheduledDateTime = json['scheduledDateTime'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['assignedUsers'] = this.assignedUsers;
    data['subTasks'] = this.subTasks;
    data['createdBy'] = this.createdBy;

    data['scheduledDateTime'] = this.scheduledDateTime;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
