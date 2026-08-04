class Donations {
  final String username;
  final String email;
  final String firstname;
  final String lastname;
  final String phone;
  final String createdAt;
  final DonationsMap donation;
  final PaymentMap payment;
  Donations(
      {required this.username,
      required this.email,
      required this.firstname,
      required this.lastname,
      required this.phone,
      required this.createdAt,
      required this.donation,
      required this.payment});

  factory Donations.fromJson(Map<String, dynamic> json) {
    return Donations(
        createdAt: json['createdAt'],
        username: json['username'],
        email: json['email'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        phone: json['phone'],
        donation: json['donation'],
        payment: json['payment']);
  }
}

class DonationsMap {
  final String id;
  final String name;

  DonationsMap({required this.id, required this.name});
  factory DonationsMap.fromJson(Map<String, dynamic> json) {
    return DonationsMap(id: json['id'], name: json['name']);
  }
}

class PaymentMap {
  final String status;
  final String mode;

  PaymentMap({required this.status, required this.mode});
  factory PaymentMap.fromJson(Map<String, dynamic> json) {
    return PaymentMap(status: json['id'], mode: json['name']);
  }
}

class Details {
  final String detail;

  Details({required this.detail});
  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(detail: json['details']);
  }
}
