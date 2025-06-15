class GetFinancialqrtzResponse {
  int status;
  String message;
  List<MonthYearData> data;

  GetFinancialqrtzResponse(
      {required this.status, required this.message, required this.data});

  factory GetFinancialqrtzResponse.fromJson(Map<String, dynamic> json) {
    return GetFinancialqrtzResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => MonthYearData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class MonthYearData {
  String monthYear;

  MonthYearData({required this.monthYear});

  factory MonthYearData.fromJson(Map<String, dynamic> json) {
    return MonthYearData(
      monthYear: json['monthYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthYear': monthYear,
    };
  }
}
