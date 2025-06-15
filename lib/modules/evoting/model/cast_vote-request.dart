import 'dart:convert';
import '../../../utils/base_request.dart';

class CastVoteRequest extends BaseRequest {
  String? dpId;
  String? clientId;
  String? evenId;
  List<ResolutionDetail>? resolutionDetails;

  CastVoteRequest(
      {this.dpId,
      this.clientId,
      this.evenId,
      this.resolutionDetails,
      String? channelId,
      String? deviceId,
      String? deviceOS,
      String? signCS,
      String? sessionId,
      String? data})
      : super(
            channelId: channelId,
            deviceId: deviceId,
            deviceOS: deviceOS,
            signCS: signCS,
            sessionId: sessionId,
            data: data);

  CastVoteRequest.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      dpId = decodedData['dpId'];
      clientId = decodedData['clientId'];
      evenId = decodedData['evenId'];
      if (decodedData['resolutionDetails'] != null) {
        resolutionDetails = (decodedData['resolutionDetails'] as List)
            .map((item) => ResolutionDetail.fromJson(item))
            .toList();
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'dpId': dpId,
      'clientId': clientId,
      'evenId': evenId,
      'resolutionDetails':
          resolutionDetails?.map((item) => item.toJson()).toList(),
    });
    return data;
  }

  @override
  String toString() {
    return (channelId ?? '') +
        (sessionId ?? '') +
        (deviceId ?? '') +
        (deviceOS ?? '') +
        jsonEncode({
          'dpId': dpId,
          'clientId': clientId,
          'evenId': evenId,
          'resolutionDetails':
              resolutionDetails?.map((item) => item.toJson()).toList(),
        });
  }
}

class ResolutionDetail {
  String? resolutionId;
  String? optionId;
  String? votesCast;

  ResolutionDetail({this.resolutionId, this.optionId, this.votesCast});

  ResolutionDetail.fromJson(Map<String, dynamic> json) {
    resolutionId = json['resolutionId'];
    optionId = json['optionId'];
    votesCast = json['votesCast'];
  }

  Map<String, dynamic> toJson() {
    return {
      'resolutionId': resolutionId,
      'optionId': optionId,
      'votesCast': votesCast,
    };
  }
}
