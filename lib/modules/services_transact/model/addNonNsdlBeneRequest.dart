class GetNonNSDLBeneficiaryRequest {
  NonNSDLBeneficiary? nonNSDLBeneficiary;
  SessionDataNonNsdl? sessionData;

  GetNonNSDLBeneficiaryRequest({this.nonNSDLBeneficiary, this.sessionData});

  GetNonNSDLBeneficiaryRequest.fromJson(Map<String, dynamic> json) {
    nonNSDLBeneficiary = json['nonNSDLBeneficiary'] != null
        ? new NonNSDLBeneficiary.fromJson(json['nonNSDLBeneficiary'])
        : null;
    sessionData = json['sessionData'] != null
        ? new SessionDataNonNsdl.fromJson(json['sessionData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nonNSDLBeneficiary != null) {
      data['nonNSDLBeneficiary'] = this.nonNSDLBeneficiary!.toJson();
    }
    if (this.sessionData != null) {
      data['sessionData'] = this.sessionData!.toJson();
    }
    return data;
  }
}

class NonNSDLBeneficiary {
  String? srcDpId;
  String? srcClientId;
  String? dematAccount;
  String? pan;

  NonNSDLBeneficiary(
      {this.srcDpId, this.srcClientId, this.dematAccount, this.pan});

  NonNSDLBeneficiary.fromJson(Map<String, dynamic> json) {
    srcDpId = json['srcDpId'];
    srcClientId = json['srcClientId'];
    dematAccount = json['dematAccount'];
    pan = json['pan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srcDpId'] = this.srcDpId;
    data['srcClientId'] = this.srcClientId;
    data['dematAccount'] = this.dematAccount;
    data['pan'] = this.pan;
    return data;
  }
}

class SessionDataNonNsdl {
  String? sessionId;

  SessionDataNonNsdl({this.sessionId});

  SessionDataNonNsdl.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sessionId'] = this.sessionId;
    return data;
  }
}
