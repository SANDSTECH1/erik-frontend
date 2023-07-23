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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['assignedUsers'] = assignedUsers;
    data['subTasks'] = subTasks;
    data['createdBy'] = createdBy;

    data['scheduledDateTime'] = scheduledDateTime;
    data['_id'] = sId;
    data['__v'] = iV;
    return data;
  }
}
