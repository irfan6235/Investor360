class CommonRequest {
  String? sessionId;

  CommonRequest({this.sessionId});
  CommonRequest.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['sessionId'] = sessionId;

    return data;
  }

  @override
  String toString() {
    return sessionId!;
  }
}