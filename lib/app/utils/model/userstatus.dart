class UserStatus {
  String? userId;
  String? status;
  UserStatus(
      {this.userId,
        this.status
      });

  UserStatus.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['userId'] = this.userId;
    return data;
  }
}