class userModel {
  String? sId;
  String? name;
  String? email;
  String? password;
  String? image;
  bool? otpVerified;

  int? iV;
  String? userToken;

  userModel(
      {this.sId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.otpVerified,
      this.iV,
      this.userToken});

  userModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
    otpVerified = json['otpVerified'];

    iV = json['__v'];
    userToken = json['userToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['image'] = this.image;
    data['otpVerified'] = this.otpVerified;

    data['__v'] = this.iV;
    data['userToken'] = this.userToken;
    return data;
  }
}
