class Token {
  String? token;
  late DateTime expiredAt;

  Token({
    required this.token,
  });

  setExpiredAt(int expiredAt) {
    this.expiredAt = DateTime(expiredAt);
  }

  factory Token.fromJson(
    Map<String, dynamic> json,
  ) {
    return Token(
      token: json['token'],
    );
  }
}
