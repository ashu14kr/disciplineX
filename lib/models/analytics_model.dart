class AnalyticsModel {
  final String uid;
  final String startDate;
  final int totalMinSpend;
  final int totalMinPlanned;
  final List<String> activeDays;
  final Map<String, Map<String, double>> weeks;

  AnalyticsModel({
    required this.uid,
    required this.startDate,
    required this.totalMinSpend,
    required this.totalMinPlanned,
    required this.activeDays,
    required this.weeks,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      uid: json['uid'] ?? '',
      startDate: json['startDate'] ?? '',
      totalMinSpend: (json['totalMinSpend'] as num?)?.toInt() ?? 0,
      totalMinPlanned: (json['totalMinPlanned'] as num?)?.toInt() ?? 0,
      activeDays: List<String>.from(json['activeDays'] ?? []),
      weeks: (json['weeks'] as Map<String, dynamic>?)?.map(
            (week, days) => MapEntry(
              week,
              (days as Map<String, dynamic>).map(
                (day, minutes) => MapEntry(day, (minutes as num).toDouble()),
              ),
            ),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'startDate': startDate,
      'totalMinSpend': totalMinSpend,
      'totalMinPlanned': totalMinPlanned,
      'activeDays': activeDays,
      'weeks': weeks.map(
        (week, days) => MapEntry(
          week,
          days.map((day, minutes) => MapEntry(day, minutes)),
        ),
      ),
    };
  }
}
