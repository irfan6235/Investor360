class GetEspEventListResponse {
  List<Data>? data;

  GetEspEventListResponse({this.data});

  GetEspEventListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? eventEndDate;
  String? espCode;
  String? evenId;
  String? isinDesc;
  String? issuerName;
  String? eventEndTime;
  String? eventStartTime;
  String? eventPurpose;
  String? eventType;
  String? espName;
  String? isin;
  String? eventStartDate;
  String? resultDate;

  Data(
      {this.eventEndDate,
      this.espCode,
      this.evenId,
      this.isinDesc,
      this.issuerName,
      this.eventEndTime,
      this.eventStartTime,
      this.eventPurpose,
      this.eventType,
      this.espName,
      this.isin,
      this.eventStartDate,
      this.resultDate});

  Data.fromJson(Map<String, dynamic> json) {
    eventEndDate = json['eventEndDate'];
    espCode = json['espCode'];
    evenId = json['evenId'];
    isinDesc = json['isinDesc'];
    issuerName = json['issuerName'];
    eventEndTime = json['eventEndTime'];
    eventStartTime = json['eventStartTime'];
    eventPurpose = json['eventPurpose'];
    eventType = json['eventType'];
    espName = json['espName'];
    isin = json['isin'];
    eventStartDate = json['eventStartDate'];
    resultDate = json['resultDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventEndDate'] = this.eventEndDate;
    data['espCode'] = this.espCode;
    data['evenId'] = this.evenId;
    data['isinDesc'] = this.isinDesc;
    data['issuerName'] = this.issuerName;
    data['eventEndTime'] = this.eventEndTime;
    data['eventStartTime'] = this.eventStartTime;
    data['eventPurpose'] = this.eventPurpose;
    data['eventType'] = this.eventType;
    data['espName'] = this.espName;
    data['isin'] = this.isin;
    data['eventStartDate'] = this.eventStartDate;
    data['resultDate'] = this.resultDate;
    return data;
  }
}
