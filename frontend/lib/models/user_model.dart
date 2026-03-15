class UserModel {
  final String uid;
  final String email;
  final String? nickname;
  final int? age;
  final String? gender;
  final String? profileImageUrl;
  final String? bio;

  UserModel({
    required this.uid,
    required this.email,
    this.nickname,
    this.age,
    this.gender,
    this.profileImageUrl,
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'age': age,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
    };
  }
}
