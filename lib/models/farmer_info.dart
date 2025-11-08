class FarmerInfo {
  final String name;
  final String farmName;
  final String email;
  final String phone;
  final String location;
  final String farmSize;
  // final String experience;

  FarmerInfo({
    required this.name,
    required this.farmName,
    required this.email,
    required this.phone,
    required this.location,
    required this.farmSize,
    // required this.experience,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'farmName': farmName,
      'email': email,
      'phone': phone,
      'location': location,
      'farmSize': farmSize,
      // 'experience': experience,
    };
  }

  factory FarmerInfo.fromJson(Map<String, dynamic> json) {
    return FarmerInfo(
      name: json['name'] ?? '',
      farmName: json['farmName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      farmSize: json['farmSize'] ?? '',
      // experience: json['experience'] ?? '',
    );
  }
}
