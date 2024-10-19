class LeaveRequest {
  final String requestId;
  final String fromDate;
  final String toDate;
  final String reason;
  final String status;
  final String userUid;
  final String userName;
  final String userEmail;
  final String userProfilePic;
  final int userClass;

  LeaveRequest({
    required this.requestId,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.userProfilePic,
    required this.userClass, 
  });
}
