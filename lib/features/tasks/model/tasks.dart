import 'package:erick/features/onboarding/model/user.dart';
import 'package:flutter/material.dart';

class taskByDate {
  String? sId;
  String? title;
  String? description;
  List<userModel>? assignedUsers;
  List<SubTasks>? subTasks;
  userModel? createdBy;
  String? scheduledDateTime;
  String? estimatedTime;
  String? price;
  int? iV;

  taskByDate(
      {this.sId,
      this.title,
      this.description,
      this.assignedUsers,
      this.subTasks,
      this.createdBy,
      this.estimatedTime,
      this.price,
      this.scheduledDateTime,
      this.iV});

  taskByDate.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    if (json['assignedUsers'] != null) {
      assignedUsers = <userModel>[];
      json['assignedUsers'].forEach((v) {
        assignedUsers!.add(new userModel.fromJson(v));
      });
    }

    if (json['subTasks'] != null) {
      subTasks = <SubTasks>[];
      json['subTasks'].forEach((v) {
        subTasks!.add(new SubTasks.fromJson(v));
      });
    }
    createdBy = json['createdBy'] != null
        ? new userModel.fromJson(json['createdBy'])
        : null;
    scheduledDateTime = json['scheduledDateTime'];
    estimatedTime = json['estimatedTime'];
    price = json['price'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.assignedUsers != null) {
      data['assignedUsers'] =
          this.assignedUsers!.map((v) => v.toJson()).toList();
    }
    data['subTasks'] = this.subTasks;

    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['scheduledDateTime'] = this.scheduledDateTime;
    data['estimatedTime'] = this.estimatedTime;
    data['price'] = this.price;
    data['__v'] = this.iV;
    return data;
  }
}

class SubTasks {
  String? subTaskTitle;
  String? subTaskDescription;
  String? task;
  String? createdBy;
  String? scheduledDateTime;
  List<String>? assignedUsers;
  String? estimatedTime;
  String? price;
  String? sId;
  int? iV;

  SubTasks(
      {this.subTaskTitle,
      this.subTaskDescription,
      this.task,
      this.createdBy,
      this.scheduledDateTime,
      this.assignedUsers,
      this.estimatedTime,
      this.price,
      this.sId,
      this.iV});

  SubTasks.fromJson(Map<String, dynamic> json) {
    subTaskTitle = json['subTaskTitle'];
    subTaskDescription = json['subTaskDescription'];
    task = json['task'];
    //createdBy = json['createdBy'];
    scheduledDateTime = json['scheduledDateTime'];
    assignedUsers = json['assignedUsers'].cast<String>();
    estimatedTime = json['estimatedTime'];
    price = json['price'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subTaskTitle'] = this.subTaskTitle;
    data['subTaskDescription'] = this.subTaskDescription;
    data['task'] = this.task;
    //data['createdBy'] = this.createdBy;
    data['scheduledDateTime'] = this.scheduledDateTime;
    data['assignedUsers'] = this.assignedUsers;
    data['estimatedTime'] = this.estimatedTime;
    data['price'] = this.price;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}

// class SubTasks {
//   String? subTaskTitle;
//   String? subTaskDescription;
//   String? task;
//   String? createdBy;
//   String? scheduledDateTime;
//   List<userModel>? assignedUsers;
//   String? estimatedTime;
//   String? price;
//   String? sId;
//   int? iV;

//   SubTasks(
//       {this.subTaskTitle,
//       this.subTaskDescription,
//       this.task,
//       this.createdBy,
//       this.scheduledDateTime,
//       this.assignedUsers,
//       this.estimatedTime,
//       this.price,
//       this.sId,
//       this.iV});

//   SubTasks.fromJson(Map<String, dynamic> json) {
//     subTaskTitle = json['subTaskTitle'];
//     subTaskDescription = json['subTaskDescription'];
//     task = json['task'];
//     createdBy = json['createdBy'];
//     scheduledDateTime = json['scheduledDateTime'];
//     assignedUsers = json['assignedUsers'].cast<String>();
//     estimatedTime = json['estimatedTime'];
//     price = json['price'];
//     sId = json['_id'];
//     iV = json['__v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['subTaskTitle'] = this.subTaskTitle;
//     data['subTaskDescription'] = this.subTaskDescription;
//     data['task'] = this.task;
//     data['createdBy'] = this.createdBy;
//     data['scheduledDateTime'] = this.scheduledDateTime;
//     data['assignedUsers'] = this.assignedUsers;
//     data['estimatedTime'] = this.estimatedTime;
//     data['price'] = this.price;
//     data['_id'] = this.sId;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
