class UserModel {
  String? name;
  String? phone;
  String? id;
  String? childEmail;
  String? parentEmail;
  String? type;
  UserModel(
      {this.name,
      this.childEmail,
      this.id,
      this.parentEmail,
      this.phone,
      this.type});

  Map<String, dynamic> tojson() => {
        'name': name,
        'phone': phone,
        'id': id,
        'childEmail': childEmail,
        'parentEmail': parentEmail,
        'type': type
      };
}
