import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String type;
  final List<Address> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.type,
    required this.addresses,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a User from a Map (e.g., from Firestore)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      type: map['type'] ?? 'customer',
      addresses: (map['addresses'] as List?)
              ?.map((address) => Address.fromMap(address))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is DateTime
              ? map['createdAt']
              : (map['createdAt'] as Timestamp).toDate())
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] is DateTime
              ? map['updatedAt']
              : (map['updatedAt'] as Timestamp).toDate())
          : DateTime.now(),
    );
  }

  // Convert User to a Map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'type': type,
      'addresses': addresses.map((address) => address.toMap()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }


  // fromJson method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      type: json['type'],
      addresses: List<Address>.from(json['addresses'].map((address) => Address.fromMap(address))),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Address {
  final String name;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  Address({
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  // Factory constructor to create an Address from a Map
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      name: map['name'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  // Convert Address to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }
}
