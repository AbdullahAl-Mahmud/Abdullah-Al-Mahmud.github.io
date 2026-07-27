enum SchedulePeriod { morning, afternoon, evening }

extension SchedulePeriodX on SchedulePeriod {
  String get label => switch (this) {
        SchedulePeriod.morning => 'Morning',
        SchedulePeriod.afternoon => 'Afternoon',
        SchedulePeriod.evening => 'Evening',
      };
}

class ScheduleModel {
  const ScheduleModel({
    required this.id,
    required this.time,
    required this.busId,
    required this.routeId,
    required this.period,
    required this.status,
  });

  final String id;
  final String time;
  final String busId;
  final String routeId;
  final SchedulePeriod period;
  final String status;
}
