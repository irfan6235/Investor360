class AddBeneficiaryResponse {
  final dynamic srcDpId;
  final dynamic srcClientId;
  final dynamic dpId;
  final dynamic clientId;
  final dynamic name;
  final dynamic pan;

  AddBeneficiaryResponse({
    required this.srcDpId,
    required this.srcClientId,
    required this.dpId,
    required this.clientId,
    required this.name,
    required this.pan,
  });

  // Factory method to create an instance of AddBeneficiaryResponse from JSON
  factory AddBeneficiaryResponse.fromJson(Map<String, dynamic> json) {
    return AddBeneficiaryResponse(
      srcDpId: json['srcDpId'],
      srcClientId: json['srcClientId'],
      dpId: json['dpId'],
      clientId: json['clientId'],
      name: json['name'],
      pan: json['pan'],
    );
  }

  // Method to convert an instance of AddBeneficiaryResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'srcDpId': srcDpId,
      'srcClientId': srcClientId,
      'dpId': dpId,
      'clientId': clientId,
      'name': name,
      'pan': pan,
    };
  }
}
