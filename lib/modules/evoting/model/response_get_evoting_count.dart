class GetEvotingCountResponse {
  bool? evotingFlag;
  String? clientId;
  int? pendingVoteCount;
  String? dpId;
  int? evotingActiveCount;
  int? totalVotes; // Add this if you want to keep track of total votes

  GetEvotingCountResponse({
    this.evotingFlag,
    this.clientId,
    this.pendingVoteCount,
    this.dpId,
    this.evotingActiveCount,
    this.totalVotes,
  });

  // Factory method to create a GetEvotingCountResponse from JSON
  GetEvotingCountResponse.fromJson(Map<String, dynamic> json) {
    evotingFlag = json['evotingFlag'];
    clientId = json['clientId'];
    pendingVoteCount = json['pendingVoteCount'];
    dpId = json['dpId'];
    evotingActiveCount = json['evotingActiveCount'];
    totalVotes = evotingActiveCount!; // Calculate total votes
  }

  // Method to convert GetEvotingCountResponse to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['evotingFlag'] = evotingFlag;
    dataMap['clientId'] = clientId;
    dataMap['pendingVoteCount'] = pendingVoteCount;
    dataMap['dpId'] = dpId;
    dataMap['evotingActiveCount'] = evotingActiveCount;
    dataMap['totalVotes'] = totalVotes; // Include total votes if needed
    return dataMap;
  }
}
