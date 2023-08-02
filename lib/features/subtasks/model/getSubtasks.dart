class subtasks {
  String? subTaskTitle;
  String? subTaskDescription;
  String? task;
  String? createdBy;
  String? sId;
  int? iV;

  subtasks(
      {this.subTaskTitle,
      this.subTaskDescription,
      this.task,
      this.createdBy,
      this.sId,
      this.iV});

  subtasks.fromJson(Map<String, dynamic> json) {
    subTaskTitle = json['subTaskTitle'];
    subTaskDescription = json['subTaskDescription'];
    task = json['task'];
    createdBy = json['createdBy'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subTaskTitle'] = this.subTaskTitle;
    data['subTaskDescription'] = this.subTaskDescription;
    data['task'] = this.task;
    data['createdBy'] = this.createdBy;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
