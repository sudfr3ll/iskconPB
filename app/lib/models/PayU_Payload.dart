class PaypayLoad {
  final String key;
  final String txnid;
  final double amount;
  final String productinfo;
  final String email;
  final String firstname;
  final String lastname;
  final String phone;
  final String furl;
  final String surl;
  final String curl;
  final String hash;
  PaypayLoad(
      {required this.key,
      required this.txnid,
      required this.amount,
      required this.productinfo,
      required this.email,
      required this.firstname,
      required this.lastname,
      required this.phone,
      required this.curl,
      required this.furl,
      required this.hash,
      required this.surl});

  factory PaypayLoad.fromJson(Map<String, dynamic> json) {
    return PaypayLoad(
        key: json['key'],
        txnid: json['txnid'],
        amount: json['amount'],
        productinfo: json['productinfo'],
        email: json['email'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        phone: json['phone'],
        curl: json['curl'],
        furl: json['furl'],
        surl: json['surl'],
        hash: json['hash']);
  }
}
