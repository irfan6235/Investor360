class GetNsdlHoldingDataResponse {
  dynamic? mobile;
  dynamic? pan;
  dynamic? name;
  List<DematAccountList>? dematAccountList;
  List<HoldingDataList>? holdingDataList;
  dynamic? transactionList;
  dynamic? authenticated;
  dynamic? otpVal;
  dynamic? registrationOtpValidated;
  dynamic? publicKeyPEM;

  GetNsdlHoldingDataResponse(
      {this.mobile,
      this.pan,
      this.name,
      this.dematAccountList,
      this.holdingDataList,
      this.transactionList,
      this.authenticated,
      this.otpVal,
      this.registrationOtpValidated,
      this.publicKeyPEM});

  GetNsdlHoldingDataResponse.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    pan = json['pan'];
    name = json['name'];
    if (json['dematAccountList'] != null) {
      dematAccountList = <DematAccountList>[];
      json['dematAccountList'].forEach((v) {
        dematAccountList!.add(new DematAccountList.fromJson(v));
      });
    }
    if (json['holdingDataList'] != null) {
      holdingDataList = <HoldingDataList>[];
      json['holdingDataList'].forEach((v) {
        holdingDataList!.add(new HoldingDataList.fromJson(v));
      });
    }
    transactionList = json['transactionList'];
    authenticated = json['authenticated'];
    otpVal = json['otpVal'];
    registrationOtpValidated = json['registrationOtpValidated'];
    publicKeyPEM = json['publicKeyPEM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['pan'] = this.pan;
    data['name'] = this.name;
    if (this.dematAccountList != null) {
      data['dematAccountList'] =
          this.dematAccountList!.map((v) => v.toJson()).toList();
    }
    if (this.holdingDataList != null) {
      data['holdingDataList'] =
          this.holdingDataList!.map((v) => v.toJson()).toList();
    }
    data['transactionList'] = this.transactionList;
    data['authenticated'] = this.authenticated;
    data['otpVal'] = this.otpVal;
    data['registrationOtpValidated'] = this.registrationOtpValidated;
    data['publicKeyPEM'] = this.publicKeyPEM;
    return data;
  }
}

class DematAccountList {
  dynamic? dpId;
  dynamic? clientId;
  dynamic? activationDate;
  dynamic? name;
  dynamic? emailId;
  dynamic? address;
  dynamic? statusCode;
  dynamic? statusDescription;
  dynamic? holderIndicator;
  dynamic? bankName;
  dynamic? bankIFSC;
  dynamic? bankAccountNumber;
  dynamic? dpName;
  List<NomineeList>? nomineeList;

  DematAccountList({
    this.dpId,
    this.clientId,
    this.activationDate,
    this.name,
    this.emailId,
    this.address,
    this.statusCode,
    this.statusDescription,
    this.holderIndicator,
    this.bankName,
    this.bankIFSC,
    this.bankAccountNumber,
    this.dpName,
    this.nomineeList,
  });

  DematAccountList.fromJson(Map<String, dynamic> json) {
    dpId = json['dpId'];
    clientId = json['clientId'];
    activationDate = json['activationDate'];
    name = json['name'];
    emailId = json['emailId'];
    address = json['address'];
    statusCode = json['statusCode'];
    statusDescription = json['statusDescription'];
    holderIndicator = json['holderIndicator'];
    bankName = json['bankName'];
    bankIFSC = json['bankIFSC'];
    bankAccountNumber = json['bankAccountNumber'];
    dpName = json['dpName'];
    if (json['nomineeList'] != null) {
      nomineeList = <NomineeList>[];
      json['nomineeList'].forEach((v) {
        nomineeList!.add(new NomineeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dpId'] = this.dpId;
    data['clientId'] = this.clientId;
    data['activationDate'] = this.activationDate;
    data['name'] = this.name;
    data['emailId'] = this.emailId;
    data['address'] = this.address;
    data['statusCode'] = this.statusCode;
    data['statusDescription'] = this.statusDescription;
    data['holderIndicator'] = this.holderIndicator;
    data['bankName'] = this.bankName;
    data['bankIFSC'] = this.bankIFSC;
    data['bankAccountNumber'] = this.bankAccountNumber;
    data['dpName'] = this.dpName;
    if (this.nomineeList != null) {
      data['nomineeList'] = this.nomineeList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class NomineeList {
  dynamic? priority;
  dynamic? name;
  dynamic? pan;
  dynamic? sharePercentage;

  NomineeList({
    this.priority,
    this.name,
    this.pan,
    this.sharePercentage,
  });

  NomineeList.fromJson(Map<String, dynamic> json) {
    priority = json['priority'];
    name = json['name'];
    pan = json['pan'];
    sharePercentage = json['sharePercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priority'] = this.priority;
    data['name'] = this.name;
    data['pan'] = this.pan;
    data['sharePercentage'] = this.sharePercentage;

    return data;
  }
}

class HoldingDataList {
  dynamic? dpId;
  dynamic? clientId;
  dynamic? isin;
  dynamic? issuerName;
  dynamic? lastBookingDate;
  dynamic? unlockBalance;
  dynamic? lockBalance;
  dynamic? blockBalance;
  dynamic? dematUnlockBalance;
  dynamic? rematUnlockBalance;
  dynamic? rematLockBalance;
  dynamic? transitBalance;
  dynamic? pledgeUnlockBalance;
  dynamic? pledgeLockBalance;
  dynamic? pledgeTransitUnlockBalance;
  dynamic? pledgeTransitLockBalance;
  dynamic? deliveryTransitBalance;
  dynamic? recieptTransitBalance;
  dynamic? holdUnlockBalance;
  dynamic? holdLockBalance;
  dynamic? holdTransitUnlockBalance;
  dynamic? holdTransitLockBalance;
  dynamic? securityType;
  dynamic? securityTypeDescription;
  dynamic? securityGroup;
  dynamic? securityTypeDescriptionCode;
  dynamic? securityGroupCode;
  dynamic? couponRate;
  dynamic? totalPosition;
  dynamic? closingPrice;
  dynamic? totalValue;
  dynamic? companyName;
  dynamic? percentageHolding;
  dynamic? acquisitionCost;
  dynamic? acquisitionValue;
  dynamic? currentValue;
  dynamic? unrealizedGainLoss;
  dynamic? xirr;
  CompanyData? companyData;

  HoldingDataList(
      {this.dpId,
      this.clientId,
      this.isin,
      this.issuerName,
      this.lastBookingDate,
      this.unlockBalance,
      this.lockBalance,
      this.blockBalance,
      this.dematUnlockBalance,
      this.rematUnlockBalance,
      this.rematLockBalance,
      this.transitBalance,
      this.pledgeUnlockBalance,
      this.pledgeLockBalance,
      this.pledgeTransitUnlockBalance,
      this.pledgeTransitLockBalance,
      this.deliveryTransitBalance,
      this.recieptTransitBalance,
      this.holdUnlockBalance,
      this.holdLockBalance,
      this.holdTransitUnlockBalance,
      this.holdTransitLockBalance,
      this.securityType,
      this.securityTypeDescription,
      this.securityGroup,
      this.securityTypeDescriptionCode,
      this.securityGroupCode,
      this.couponRate,
      this.totalPosition,
      this.closingPrice,
      this.totalValue,
      this.companyName,
      this.percentageHolding,
      this.acquisitionCost,
      this.acquisitionValue,
      this.currentValue,
      this.unrealizedGainLoss,
      this.xirr,
      this.companyData});

  HoldingDataList.fromJson(Map<String, dynamic> json) {
    dpId = json['dpId'];
    clientId = json['clientId'];
    isin = json['isin'];
    issuerName = json['issuerName'];
    lastBookingDate = json['lastBookingDate'];
    unlockBalance = json['unlockBalance'];
    lockBalance = json['lockBalance'];
    blockBalance = json['blockBalance'];
    dematUnlockBalance = json['dematUnlockBalance'];
    rematUnlockBalance = json['rematUnlockBalance'];
    rematLockBalance = json['rematLockBalance'];
    transitBalance = json['transitBalance'];
    pledgeUnlockBalance = json['pledgeUnlockBalance'];
    pledgeLockBalance = json['pledgeLockBalance'];
    pledgeTransitUnlockBalance = json['pledgeTransitUnlockBalance'];
    pledgeTransitLockBalance = json['pledgeTransitLockBalance'];
    deliveryTransitBalance = json['deliveryTransitBalance'];
    recieptTransitBalance = json['recieptTransitBalance'];
    holdUnlockBalance = json['holdUnlockBalance'];
    holdLockBalance = json['holdLockBalance'];
    holdTransitUnlockBalance = json['holdTransitUnlockBalance'];
    holdTransitLockBalance = json['holdTransitLockBalance'];
    securityType = json['securityType'];
    securityTypeDescription = json['securityTypeDescription'];
    securityGroup = json['securityGroup'];
    securityTypeDescriptionCode = json['securityTypeDescriptionCode'];
    securityGroupCode = json['securityGroupCode'];
    couponRate = json['couponRate'];
    totalPosition = json['totalPosition'];
    closingPrice = json['closingPrice'];
    totalValue = json['totalValue'];
    companyName = json['companyName'];
    percentageHolding = json['percentageHolding'];
    acquisitionCost = json['acquisitionCost'];
    acquisitionValue = json['acquisitionValue'];
    currentValue = json['currentValue'];
    unrealizedGainLoss = json['unrealizedGainLoss'];
    xirr = json['xirr'];
    companyData = json['companyData'] != null
        ? new CompanyData.fromJson(json['companyData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dpId'] = this.dpId;
    data['clientId'] = this.clientId;
    data['isin'] = this.isin;
    data['issuerName'] = this.issuerName;
    data['lastBookingDate'] = this.lastBookingDate;
    data['unlockBalance'] = this.unlockBalance;
    data['lockBalance'] = this.lockBalance;
    data['blockBalance'] = this.blockBalance;
    data['dematUnlockBalance'] = this.dematUnlockBalance;
    data['rematUnlockBalance'] = this.rematUnlockBalance;
    data['rematLockBalance'] = this.rematLockBalance;
    data['transitBalance'] = this.transitBalance;
    data['pledgeUnlockBalance'] = this.pledgeUnlockBalance;
    data['pledgeLockBalance'] = this.pledgeLockBalance;
    data['pledgeTransitUnlockBalance'] = this.pledgeTransitUnlockBalance;
    data['pledgeTransitLockBalance'] = this.pledgeTransitLockBalance;
    data['deliveryTransitBalance'] = this.deliveryTransitBalance;
    data['recieptTransitBalance'] = this.recieptTransitBalance;
    data['holdUnlockBalance'] = this.holdUnlockBalance;
    data['holdLockBalance'] = this.holdLockBalance;
    data['holdTransitUnlockBalance'] = this.holdTransitUnlockBalance;
    data['holdTransitLockBalance'] = this.holdTransitLockBalance;
    data['securityType'] = this.securityType;
    data['securityTypeDescription'] = this.securityTypeDescription;
    data['securityGroup'] = this.securityGroup;
    data['securityTypeDescriptionCode'] = this.securityTypeDescriptionCode;
    data['securityGroupCode'] = this.securityGroupCode;
    data['couponRate'] = this.couponRate;
    data['totalPosition'] = this.totalPosition;
    data['closingPrice'] = this.closingPrice;
    data['totalValue'] = this.totalValue;
    data['companyName'] = this.companyName;
    data['percentageHolding'] = this.percentageHolding;
    data['acquisitionCost'] = this.acquisitionCost;
    data['acquisitionValue'] = this.acquisitionValue;
    data['currentValue'] = this.currentValue;
    data['unrealizedGainLoss'] = this.unrealizedGainLoss;
    data['xirr'] = this.xirr;
    if (this.companyData != null) {
      data['companyData'] = this.companyData!.toJson();
    }
    return data;
  }
}

class CompanyData {
  dynamic? companyCode;
  dynamic? businessSector;
  dynamic? marketCap;
  dynamic? companyName;

  CompanyData(
      {this.companyCode,
      this.businessSector,
      this.marketCap,
      this.companyName});

  CompanyData.fromJson(Map<String, dynamic> json) {
    companyCode = json['companyCode'];
    businessSector = json['businessSector'];
    marketCap = json['marketCap'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyCode'] = this.companyCode;
    data['businessSector'] = this.businessSector;
    data['marketCap'] = this.marketCap;
    data['companyName'] = this.companyName;
    return data;
  }
}
