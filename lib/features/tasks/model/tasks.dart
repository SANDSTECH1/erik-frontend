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
  String? sId;
  String? subTaskTitle;
  String? subTaskDescription;
  String? task;
  String? scheduledDateTime;
  String? estimatedTime;
  String? price;
  userModel? createdBy;
  int? iV;
  List<userModel>? assignedUsers;
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  SubTasks(
      {this.sId,
      this.subTaskTitle,
      this.subTaskDescription,
      this.task,
      this.scheduledDateTime,
      this.estimatedTime,
      this.price,
      this.assignedUsers,
      this.selectedDate,
      this.iV});

  SubTasks.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    subTaskTitle = json['subTaskTitle'];
    subTaskDescription = json['subTaskDescription'];
    task = json['task'];
    scheduledDateTime = json['scheduledDateTime'];
    if (json['assignedUsers'] != null) {
      assignedUsers = <userModel>[];
      json['assignedUsers'].forEach((v) {
        assignedUsers!.add(new userModel.fromJson(v));
      });
    }
    // createdBy = json['createdBy'] != null
    //     ? new userModel.fromJson(json['createdBy'])
    //     : null;
    estimatedTime = json['estimatedTime'];
    price = json['price'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['subTaskTitle'] = this.subTaskTitle;
    data['subTaskDescription'] = this.subTaskDescription;
    data['task'] = this.task;
    data['scheduledDateTime'] = this.scheduledDateTime;
    if (this.assignedUsers != null) {
      data['assignedUsers'] =
          this.assignedUsers!.map((v) => v.toJson()).toList();
    }
    // if (this.createdBy != null) {
    //   data['createdBy'] = this.createdBy!.toJson();
    // }
    data['estimatedTime'] = this.estimatedTime;
    data['price'] = this.price;
    data['__v'] = this.iV;
    return data;
  }
}
