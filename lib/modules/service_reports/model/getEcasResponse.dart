// class EcasResponse {
//   int? status;
//   String? message;
//   List<DocList>? docList;

//   EcasResponse({this.status, this.message, this.docList});

//   factory EcasResponse.fromJson(Map<String, dynamic> json) {
//     return EcasResponse(
//       status: json['status'],
//       message: json['message'],
//       docList: json['docList'] != null
//           ? (json['docList'] as List).map((i) => DocList.fromJson(i)).toList()
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.docList != null) {
//       data['docList'] = this.docList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class DocList {
//   String? fullKey;
//   String? fileName;

//   DocList({this.fullKey, this.fileName});

//   factory DocList.fromJson(Map<String, dynamic> json) {
//     return DocList(
//       fullKey: json['fullKey'],
//       fileName: json['fileName'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['fullKey'] = this.fullKey;
//     data['fileName'] = this.fileName;
//     return data;
//   }
// }

/*class EcasResponse {
  int? status;
  String? message;
  List<DocList>? docList;

  EcasResponse({this.status, this.message, this.docList});

  factory EcasResponse.fromJson(Map<String, dynamic> json) {
    return EcasResponse(
      status: json['status'],
      message: json['message'],
      docList: (json['data'] as List<dynamic>?)
          ?.map((item) => DocList.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.docList != null) {
      data['data'] = this.docList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocList {
  String? fullKey;
  String? fileName;

  DocList({this.fullKey, this.fileName});

  factory DocList.fromJson(Map<String, dynamic> json) {
    return DocList(
      fullKey: json['fullKey'],
      fileName: json['fileName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullKey'] = this.fullKey;
    data['fileName'] = this.fileName;
    return data;
  }
}*/


class EcasResponse {
  String? fullKey;
  String? fileName;
  String? title;

  EcasResponse({this.fullKey, this.fileName, this.title});

  EcasResponse.fromJson(Map<String, dynamic> json) {
    fullKey = json['fullKey'];
    fileName = json['fileName'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullKey'] = this.fullKey;
    data['fileName'] = this.fileName;
    data['title'] = this.title;
    return data;
  }
}