// // import 'package:erick/features/onboarding/model/user.dart';

// // class getgetSubTasks {
// //   String? sId;
// //   String? subTaskTitle;
// //   String? subTaskDescription;
// //   Task? task;
// //   userModel? createdBy;
// //   String? estimatedTime;
// //   String? price;
// //   int? iV;

// //   getgetSubTasks(
// //       {this.sId,
// //       this.subTaskTitle,
// //       this.subTaskDescription,
// //       this.task,
// //       this.createdBy,
// //       this.estimatedTime,
// //       this.price,
// //       this.iV});

// //   getgetSubTasks.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     subTaskTitle = json['subTaskTitle'];
// //     subTaskDescription = json['subTaskDescription'];
// //     task = json['task'] != null ? new Task.fromJson(json['task']) : null;
// //     createdBy = json['createdBy'] != null
// //         ? new userModel.fromJson(json['createdBy'])
// //         : null;
// //     estimatedTime = json['estimatedTime'];
// //     price = json['price'];
// //     iV = json['__v'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['subTaskTitle'] = this.subTaskTitle;
// //     data['subTaskDescription'] = this.subTaskDescription;
// //     if (this.task != null) {
// //       data['task'] = this.task!.toJson();
// //     }
// //     if (this.createdBy != null) {
// //       data['createdBy'] = this.createdBy!.toJson();
// //     }
// //     data['estimatedTime'] = this.estimatedTime;
// //     data['price'] = this.price;
// //     data['__v'] = this.iV;
// //     return data;
// //   }
// // }

// // class Task {
// //   String? sId;
// //   String? title;
// //   String? description;
// //   List<AssignedUsers>? assignedUsers;
// //   List<String>? getSubTasks;
// //   CreatedBy? createdBy;
// //   String? scheduledDateTime;
// //   String? estimatedTime;
// //   String? price;
// //   int? iV;

// //   Task(
// //       {this.sId,
// //       this.title,
// //       this.description,
// //       this.assignedUsers,
// //       this.getSubTasks,
// //       this.createdBy,
// //       this.scheduledDateTime,
// //       this.estimatedTime,
// //       this.price,
// //       this.iV});

// //   Task.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     title = json['title'];
// //     description = json['description'];
// //     if (json['assignedUsers'] != null) {
// //       assignedUsers = <AssignedUsers>[];
// //       json['assignedUsers'].forEach((v) {
// //         assignedUsers!.add(new AssignedUsers.fromJson(v));
// //       });
// //     }
// //     getSubTasks = json['getSubTasks'].cast<String>();
// //     createdBy = json['createdBy'] != null
// //         ? new CreatedBy.fromJson(json['createdBy'])
// //         : null;
// //     scheduledDateTime = json['scheduledDateTime'];
// //     estimatedTime = json['estimatedTime'];
// //     price = json['price'];
// //     iV = json['__v'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['title'] = this.title;
// //     data['description'] = this.description;
// //     if (this.assignedUsers != null) {
// //       data['assignedUsers'] =
// //           this.assignedUsers!.map((v) => v.toJson()).toList();
// //     }
// //     data['getSubTasks'] = this.getSubTasks;
// //     if (this.createdBy != null) {
// //       data['createdBy'] = this.createdBy!.toJson();
// //     }
// //     data['scheduledDateTime'] = this.scheduledDateTime;
// //     data['estimatedTime'] = this.estimatedTime;
// //     data['price'] = this.price;
// //     data['__v'] = this.iV;
// //     return data;
// //   }
// // }

// // class AssignedUsers {
// //   String? sId;
// //   String? name;
// //   String? email;
// //   String? password;
// //   String? image;
// //   bool? otpVerified;
// //   List<String>? tasks;
// //   List<String>? getSubTasks;
// //   int? iV;

// //   AssignedUsers(
// //       {this.sId,
// //       this.name,
// //       this.email,
// //       this.password,
// //       this.image,
// //       this.otpVerified,
// //       this.tasks,
// //       this.getSubTasks,
// //       this.iV});

// //   AssignedUsers.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     name = json['name'];
// //     email = json['email'];
// //     password = json['password'];
// //     image = json['image'];
// //     otpVerified = json['otpVerified'];
// //     tasks = json['tasks'].cast<String>();
// //     getSubTasks = json['getSubTasks'].cast<String>();
// //     iV = json['__v'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['name'] = this.name;
// //     data['email'] = this.email;
// //     data['password'] = this.password;
// //     data['image'] = this.image;
// //     data['otpVerified'] = this.otpVerified;
// //     data['tasks'] = this.tasks;
// //     data['getSubTasks'] = this.getSubTasks;
// //     data['__v'] = this.iV;
// //     return data;
// //   }
// // }

// // class CreatedBy {
// //   String? sId;
// //   String? name;
// //   String? email;
// //   String? password;
// //   String? image;
// //   bool? otpVerified;
// //   List<String>? tasks;
// //   List<String>? getSubTasks;
// //   int? iV;
// //   Null? otpEmail;

// //   CreatedBy(
// //       {this.sId,
// //       this.name,
// //       this.email,
// //       this.password,
// //       this.image,
// //       this.otpVerified,
// //       this.tasks,
// //       this.getSubTasks,
// //       this.iV,
// //       this.otpEmail});

// //   CreatedBy.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     name = json['name'];
// //     email = json['email'];
// //     password = json['password'];
// //     image = json['image'];
// //     otpVerified = json['otpVerified'];
// //     tasks = json['tasks'].cast<String>();
// //     getSubTasks = json['getSubTasks'].cast<String>();
// //     iV = json['__v'];
// //     otpEmail = json['otpEmail'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['name'] = this.name;
// //     data['email'] = this.email;
// //     data['password'] = this.password;
// //     data['image'] = this.image;
// //     data['otpVerified'] = this.otpVerified;
// //     data['tasks'] = this.tasks;
// //     data['getSubTasks'] = this.getSubTasks;
// //     data['__v'] = this.iV;
// //     data['otpEmail'] = this.otpEmail;
// //     return data;
// //   }
// // }
// class getSubTasks {
//   String? sId;
//   String? subTaskTitle;
//   String? subTaskDescription;
//   String? task;
//   String? estimatedTime;
//   String? price;
//   String? scheduledDateTime;
//   String? createdBy;
//   int? iV;

//   getSubTasks(
//       {this.sId,
//       this.subTaskTitle,
//       this.subTaskDescription,
//       this.task,
//       this.scheduledDateTime,
//       this.createdBy,
//       this.estimatedTime,
//       this.price,
//       this.iV});

//   getSubTasks.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     subTaskTitle = json['subTaskTitle'];
//     subTaskDescription = json['subTaskDescription'];
//     task = json['task'];
//     scheduledDateTime = json['scheduledDateTime'];
//     createdBy = json['createdBy'];
//     estimatedTime = json['estimatedTime'];
//     price = json['price'];
//     iV = json['__v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['subTaskTitle'] = this.subTaskTitle;
//     data['subTaskDescription'] = this.subTaskDescription;
//     data['task'] = this.task;
//     data['scheduledDateTime'] = this.scheduledDateTime;
//     data['createdBy'] = this.createdBy;
//     data['estimatedTime'] = this.estimatedTime;
//     data['price'] = this.price;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
