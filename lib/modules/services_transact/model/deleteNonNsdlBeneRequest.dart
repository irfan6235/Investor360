class DeleteNonNsdlBeneficiaryRequest {
  final DelNonNsdlBeneficiary nonNsdlBeneficiary;
  final DelNonSessionData sessionData;

  DeleteNonNsdlBeneficiaryRequest({
    required this.nonNsdlBeneficiary,
    required this.sessionData,
  });

  Map<String, dynamic> toJson() {
    return {
      'nonNSDLBeneficiary': nonNsdlBeneficiary.toJson(),
      'sessionData': sessionData.toJson(),
    };
  }
}

class DelNonNsdlBeneficiary {
  final String srcDpId;
  final String srcClientId;
  final String dematAccount;
  final String pan;

  DelNonNsdlBeneficiary({
    required this.srcDpId,
    required this.srcClientId,
    required this.dematAccount,
    required this.pan,
  });

  Map<String, dynamic> toJson() {
    return {
      'srcDpId': srcDpId,
      'srcClientId': srcClientId,
      'dematAccount': dematAccount,
      'pan': pan,
    };
  }
}

class DelNonSessionData {
  final String sessionId;

  DelNonSessionData({required this.sessionId});

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
    };
  }
}
