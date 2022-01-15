class AuthDTO {
  AuthDTO({
    this.authToken,
    required this.tableNum,
  });

  String? authToken;
  int tableNum;

  factory AuthDTO.fromMap(Map<String, dynamic> json) => AuthDTO(
        authToken: json["jwt"],
        tableNum: json["tableNum"]
      );

  Map<String, dynamic> toMap() => {
        "jwt": authToken,
        "tableNum": tableNum
      };
}
