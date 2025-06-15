class AddNsdlBeneficiaryRequest {
  final NsdlBeneficiary nsdlBeneficiary;
  final SessionData sessionData;

  AddNsdlBeneficiaryRequest({
    required this.nsdlBeneficiary,
    required this.sessionData,
  });

  Map<String, dynamic> toJson() {
    return {
      'nsdlBeneficiary': nsdlBeneficiary.toJson(),
      'sessionData': sessionData.toJson(),
    };
  }
}

class NsdlBeneficiary {
  final dynamic srcDpId;
  final dynamic srcClientId;
  final dynamic dpId;
  final dynamic clientId;
  final dynamic pan;

  NsdlBeneficiary({
    required this.srcDpId,
    required this.srcClientId,
    required this.dpId,
    required this.clientId,
    required this.pan,
  });

  Map<String, dynamic> toJson() {
    return {
      'srcDpId': srcDpId,
      'srcClientId': srcClientId,
      'dpId': dpId,
      'clientId': clientId,
      'pan': pan,
    };
  }
}

class SessionData {
  final String sessionId;

  SessionData({required this.sessionId});

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
    };
  }
}
