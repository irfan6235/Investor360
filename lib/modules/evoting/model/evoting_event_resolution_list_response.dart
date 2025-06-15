class EvotingEventResolutionListResponse {
  List<Data>? data;

  EvotingEventResolutionListResponse({this.data});

  EvotingEventResolutionListResponse.fromJson(Map<String, dynamic> json) {
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
  String? resolutionId;
  String? userVoteOptionId;
  String? clientId;
  String? resolutionName;
  String? resolutionFile;
  String? votesCast;
  String? dpId;
  String? resolutionDescription;
  String? optionsFlag;
  String? userVotingStatus;
  List<OptionsArray>? optionsArray;

  Data(
      {this.resolutionId,
        this.userVoteOptionId,
        this.clientId,
        this.resolutionName,
        this.resolutionFile,
        this.votesCast,
        this.dpId,
        this.resolutionDescription,
        this.optionsFlag,
        this.userVotingStatus,
        this.optionsArray});

  Data.fromJson(Map<String, dynamic> json) {
    resolutionId = json['resolutionId'];
    userVoteOptionId = json['userVoteOptionId'];
    clientId = json['clientId'];
    resolutionName = json['resolutionName'];
    resolutionFile = json['resolutionFile'];
    votesCast = json['votesCast'];
    dpId = json['dpId'];
    resolutionDescription = json['resolutionDescription'];
    optionsFlag = json['optionsFlag'];
    userVotingStatus = json['userVotingStatus'];
    if (json['optionsArray'] != null) {
      optionsArray = <OptionsArray>[];
      json['optionsArray'].forEach((v) {
        optionsArray!.add(new OptionsArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resolutionId'] = this.resolutionId;
    data['userVoteOptionId'] = this.userVoteOptionId;
    data['clientId'] = this.clientId;
    data['resolutionName'] = this.resolutionName;
    data['resolutionFile'] = this.resolutionFile;
    data['votesCast'] = this.votesCast;
    data['dpId'] = this.dpId;
    data['resolutionDescription'] = this.resolutionDescription;
    data['optionsFlag'] = this.optionsFlag;
    data['userVotingStatus'] = this.userVotingStatus;
    if (this.optionsArray != null) {
      data['optionsArray'] = this.optionsArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionsArray {
  int? optionsVoterCount;
  String? optionVotesCount;
  String? optionDescription;
  String? optionId;
  String? optionName;

  OptionsArray(
      {this.optionsVoterCount,
        this.optionVotesCount,
        this.optionDescription,
        this.optionId,
        this.optionName});

  OptionsArray.fromJson(Map<String, dynamic> json) {
    optionsVoterCount = json['optionsVoterCount'];
    optionVotesCount = json['optionVotesCount'];
    optionDescription = json['optionDescription'];
    optionId = json['optionId'];
    optionName = json['optionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionsVoterCount'] = this.optionsVoterCount;
    data['optionVotesCount'] = this.optionVotesCount;
    data['optionDescription'] = this.optionDescription;
    data['optionId'] = this.optionId;
    data['optionName'] = this.optionName;
    return data;
  }
}
