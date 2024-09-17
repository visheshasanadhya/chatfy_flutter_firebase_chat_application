
class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;
  String? phonenumber;


  UserProfile({
    required this.uid,
    required this.name,
    required this.pfpURL,
    required this.phonenumber,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    pfpURL = json['pfpURL'];
    phonenumber=json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    data['uid'] = uid;
    data['phone_number']=phonenumber;
    return data;
  }
}
