class GetBeneficiaryResponse {
  final String dpId;
  final String clientId;
  final String pan;
  final String status;
  final String? name;

  GetBeneficiaryResponse({
    required this.dpId,
    required this.clientId,
    required this.pan,
    required this.status,
    required this.name,
  });

  factory GetBeneficiaryResponse.fromJson(Map<String, dynamic> json) {
    return GetBeneficiaryResponse(
      dpId: json['dpId'],
      clientId: json['clientId'],
      pan: json['pan'],
      status: json['status'],
      name: json['name'],
    );
  }
}
