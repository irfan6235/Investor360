class ResponseEvotingEventList {
  List<Data>? data;

  ResponseEvotingEventList({this.data});

  ResponseEvotingEventList.fromJson(Map<String, dynamic> json) {
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
  List<EventList>? eventList;
  String? clientId;
  String? dpId;

  Data({this.eventList, this.clientId, this.dpId});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['eventList'] != null) {
      eventList = <EventList>[];
      json['eventList'].forEach((v) {
        eventList!.add(new EventList.fromJson(v));
      });
    }
    clientId = json['clientId'];
    dpId = json['dpId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventList != null) {
      data['eventList'] = this.eventList!.map((v) => v.toJson()).toList();
    }
    data['clientId'] = this.clientId;
    data['dpId'] = this.dpId;
    return data;
  }
}

class EventList {
  String? resultDate;
  String? cycleStartTime;
  String? cycleEndDate;
  String? votesRatio;
  String? cycleStartDate;
  String? cycleEndTime;
  String? vacancies;
  String? evenId;
  String? evotingType;
  String? recordDate;
  String? company;
  String? holdings;
  String? cycleStatus;
  String? isinName;
  String? isin;
  String? votesAllowed;

  EventList(
      {this.resultDate,
        this.cycleStartTime,
        this.cycleEndDate,
        this.votesRatio,
        this.cycleStartDate,
        this.cycleEndTime,
        this.vacancies,
        this.evenId,
        this.evotingType,
        this.recordDate,
        this.company,
        this.holdings,
        this.cycleStatus,
        this.isinName,
        this.isin,
        this.votesAllowed});

  EventList.fromJson(Map<String, dynamic> json) {
    resultDate = json['resultDate'];
    cycleStartTime = json['cycleStartTime'];
    cycleEndDate = json['cycleEndDate'];
    votesRatio = json['votesRatio'];
    cycleStartDate = json['cycleStartDate'];
    cycleEndTime = json['cycleEndTime'];
    vacancies = json['vacancies'];
    evenId = json['evenId'];
    evotingType = json['evotingType'];
    recordDate = json['recordDate'];
    company = json['company'];
    holdings = json['holdings'];
    cycleStatus = json['cycleStatus'];
    isinName = json['isinName'];
    isin = json['isin'];
    votesAllowed = json['votesAllowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultDate'] = this.resultDate;
    data['cycleStartTime'] = this.cycleStartTime;
    data['cycleEndDate'] = this.cycleEndDate;
    data['votesRatio'] = this.votesRatio;
    data['cycleStartDate'] = this.cycleStartDate;
    data['cycleEndTime'] = this.cycleEndTime;
    data['vacancies'] = this.vacancies;
    data['evenId'] = this.evenId;
    data['evotingType'] = this.evotingType;
    data['recordDate'] = this.recordDate;
    data['company'] = this.company;
    data['holdings'] = this.holdings;
    data['cycleStatus'] = this.cycleStatus;
    data['isinName'] = this.isinName;
    data['isin'] = this.isin;
    data['votesAllowed'] = this.votesAllowed;
    return data;
  }
}





/*
class ResponseEvotingEventList {
  String? message;
  String? responseCode;
  String? sessionId;
  List<Data>? data;

  ResponseEvotingEventList(
      {this.message, this.responseCode, this.sessionId, this.data});

  ResponseEvotingEventList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    responseCode = json['responseCode'];
    sessionId = json['sessionId'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['responseCode'] = this.responseCode;
    data['sessionId'] = this.sessionId;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  List<EventList>? eventList;
  String? clientId;
  String? dpId;

  Data({this.eventList, this.clientId, this.dpId});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['eventList'] != null) {
      eventList = <EventList>[];
      json['eventList'].forEach((v) {
        eventList!.add(new EventList.fromJson(v));
      });
    }
    clientId = json['clientId'];
    dpId = json['dpId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventList != null) {
      data['eventList'] = this.eventList!.map((v) => v.toJson()).toList();
    }
    data['clientId'] = this.clientId;
    data['dpId'] = this.dpId;
    return data;
  }
}

class EventList {
  String? resultDate;
  String? cycleStartTime;
  String? cycleEndDate;
  String? votesRatio;
  String? cycleStartDate;
  String? cycleEndTime;
  String? vacancies;
  String? evenId;
  String? evotingType;
  String? recordDate;
  String? company;
  String? holdings;
  String? cycleStatus;
  String? isinName;
  String? isin;
  String? votesAllowed;

  EventList(
      {this.resultDate,
        this.cycleStartTime,
        this.cycleEndDate,
        this.votesRatio,
        this.cycleStartDate,
        this.cycleEndTime,
        this.vacancies,
        this.evenId,
        this.evotingType,
        this.recordDate,
        this.company,
        this.holdings,
        this.cycleStatus,
        this.isinName,
        this.isin,
        this.votesAllowed});

  EventList.fromJson(Map<String, dynamic> json) {
    resultDate = json['resultDate'];
    cycleStartTime = json['cycleStartTime'];
    cycleEndDate = json['cycleEndDate'];
    votesRatio = json['votesRatio'];
    cycleStartDate = json['cycleStartDate'];
    cycleEndTime = json['cycleEndTime'];
    vacancies = json['vacancies'];
    evenId = json['evenId'];
    evotingType = json['evotingType'];
    recordDate = json['recordDate'];
    company = json['company'];
    holdings = json['holdings'];
    cycleStatus = json['cycleStatus'];
    isinName = json['isinName'];
    isin = json['isin'];
    votesAllowed = json['votesAllowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultDate'] = this.resultDate;
    data['cycleStartTime'] = this.cycleStartTime;
    data['cycleEndDate'] = this.cycleEndDate;
    data['votesRatio'] = this.votesRatio;
    data['cycleStartDate'] = this.cycleStartDate;
    data['cycleEndTime'] = this.cycleEndTime;
    data['vacancies'] = this.vacancies;
    data['evenId'] = this.evenId;
    data['evotingType'] = this.evotingType;
    data['recordDate'] = this.recordDate;
    data['company'] = this.company;
    data['holdings'] = this.holdings;
    data['cycleStatus'] = this.cycleStatus;
    data['isinName'] = this.isinName;
    data['isin'] = this.isin;
    data['votesAllowed'] = this.votesAllowed;
    return data;
  }
}
*/
