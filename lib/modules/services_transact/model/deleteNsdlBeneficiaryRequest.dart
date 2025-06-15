class DeleteNsdlBeneficiaryRequest {
  final DelNsdlBeneficiary nsdlBeneficiary;
  final DelSessionData sessionData;

  DeleteNsdlBeneficiaryRequest({
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

class DelNsdlBeneficiary {
  final String srcDpId;
  final String srcClientId;
  final String dpId;
  final String clientId;
  final String pan;

  DelNsdlBeneficiary({
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

class DelSessionData {
  final String sessionId;

  DelSessionData({required this.sessionId});

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
    };
  }
}
