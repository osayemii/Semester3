class Staff {
  final String? id; // Realtime Database push key; null until saved.
  final String name;
  final String email;
  final int age;
  final String phone;
  final String address;

  Staff({
    this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.phone,
    required this.address,
  });

  factory Staff.fromMap(String id, Map<dynamic, dynamic> data) {
    return Staff(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      age: data['age'] is int ? data['age'] as int : int.tryParse('${data['age']}') ?? 0,
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'phone': phone,
      'address': address,
    };
  }

  Staff copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? phone,
    String? address,
  }) {
    return Staff(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
