class Subtasks {
  bool? success;
  String? message;
  Data? data;

  Subtasks({this.success, this.message, this.data});

  Subtasks.fromJson(Map<String, dynamic> json) {
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
  String? subTaskTitle;
  String? subTaskDescription;
  String? task;
  String? scheduledDateTime;
  String? createdBy;
  String? sId;
  int? iV;

  Data(
      {this.subTaskTitle,
      this.subTaskDescription,
      this.task,
      this.scheduledDateTime,
      this.createdBy,
      this.sId,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    subTaskTitle = json['subTaskTitle'];
    subTaskDescription = json['subTaskDescription'];
    task = json['task'];
    scheduledDateTime = json['scheduledDateTime'];
    createdBy = json['createdBy'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subTaskTitle'] = this.subTaskTitle;
    data['subTaskDescription'] = this.subTaskDescription;
    data['task'] = this.task;
    data['scheduledDateTime'] = this.scheduledDateTime;
    data['createdBy'] = this.createdBy;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
