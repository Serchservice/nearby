class GoCreditCard {
  GoCreditCard({
    required this.cardType,
    required this.expMonth,
    required this.expYear,
    required this.last4,
    required this.bin,
    required this.bank,
    required this.channel,
    required this.countryCode,
    required this.accountName,
  });

  final String cardType;
  final String expMonth;
  final String expYear;
  final String last4;
  final String bin;
  final String bank;
  final String channel;
  final String countryCode;
  final String accountName;

  GoCreditCard copyWith({
    String? cardType,
    String? expMonth,
    String? expYear,
    String? last4,
    String? bin,
    String? bank,
    String? channel,
    String? countryCode,
    String? accountName,
  }) {
    return GoCreditCard(
      cardType: cardType ?? this.cardType,
      expMonth: expMonth ?? this.expMonth,
      expYear: expYear ?? this.expYear,
      last4: last4 ?? this.last4,
      bin: bin ?? this.bin,
      bank: bank ?? this.bank,
      channel: channel ?? this.channel,
      countryCode: countryCode ?? this.countryCode,
      accountName: accountName ?? this.accountName,
    );
  }

  factory GoCreditCard.fromJson(Map<String, dynamic> json){
    return GoCreditCard(
      cardType: json["card_type"] ?? "",
      expMonth: json["exp_month"] ?? "",
      expYear: json["exp_year"] ?? "",
      last4: json["last4"] ?? "",
      bin: json["bin"] ?? "",
      bank: json["bank"] ?? "",
      channel: json["channel"] ?? "",
      countryCode: json["country_code"] ?? "",
      accountName: json["account_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "card_type": cardType,
    "exp_month": expMonth,
    "exp_year": expYear,
    "last4": last4,
    "bin": bin,
    "bank": bank,
    "channel": channel,
    "country_code": countryCode,
    "account_name": accountName,
  };

  @override
  String toString(){
    return "$cardType, $expMonth, $expYear, $last4, $bin, $bank, $channel, $countryCode, $accountName, ";
  }
}