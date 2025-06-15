class GetBeneficiariesRequest {
  final String dpId;
  final String clientId;
  final SessionData sessionData;

  GetBeneficiariesRequest({
    required this.dpId,
    required this.clientId,
    required this.sessionData,
  });

  factory GetBeneficiariesRequest.fromJson(Map<String, dynamic> json) {
    return GetBeneficiariesRequest(
      dpId: json['dpId'],
      clientId: json['clientId'],
      sessionData: SessionData.fromJson(json['sessionData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dpId': dpId,
      'clientId': clientId,
      'sessionData': sessionData.toJson(),
    };
  }
}

class SessionData {
  final String sessionId;

  SessionData({required this.sessionId});

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      sessionId: json['sessionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
    };
  }
}
