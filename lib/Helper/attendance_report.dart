
class AttendanceReport {
  final  reportKey;
  final  fromDate;
  final  toDate;
  final  totalDays;
  final  totalPresent;
  final  totalAbsent;
  final  totalLeave;
  final  attendancePercentage;
  late final  grade;
  final  userUid;
  final  userName;
  final  userEmail;
  final  userProfilePic;
  final  userClass;
  final  createdAt;

  AttendanceReport({
    required this.reportKey,
    required this.fromDate,
    required this.toDate,
    required this.totalDays,
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLeave,
    required this.attendancePercentage,
    required this.grade,
    required this.createdAt, 
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.userProfilePic,
    required this.userClass,
  });
}
