enum AnnouncementPriority { normal, important, urgent }

class AnnouncementModel {
  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.dateLabel,
    required this.priority,
  });

  final String id;
  final String title;
  final String message;
  final String dateLabel;
  final AnnouncementPriority priority;
}
