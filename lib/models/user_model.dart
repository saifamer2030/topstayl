class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String language;
  final String group;
  final String country;
  final String city;
  final String address;
  final String currency;
  final bool emailVerified;
  final bool phoneVerified;
  final String registerAt;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.language,
      this.group,
      this.country,
      this.city,
      this.address,
      this.currency,
      this.emailVerified,
      this.phoneVerified,
      this.registerAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        language: json['language'] as String,
        group: json['group'] as String,
        country: json['country'] as String,
        city: json['city'] as String,
        address: json['address'] as String,
        currency: json['currency'] as String,
        phoneVerified: json['phone_verified'] as bool,
        emailVerified: json['email_verified'] as bool,
        registerAt: json['registered_at'] as String);
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, phone: $phone, language: $language, group: $group, country: $country, city: $city, address: $address, currency: $currency, emailVerified: $emailVerified, phoneVerified: $phoneVerified, registerAt: $registerAt}';
  }
}
