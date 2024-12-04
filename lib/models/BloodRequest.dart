class BloodRequest {
  final String patientName;
  final String location;
  final String contactNumber;
  final String bloodType;
  final String neededDate;
  final bool isUrgent;
  final String? additionalInfo;
  final String? fileName;

  BloodRequest({
    required this.patientName,
    required this.location,
    required this.contactNumber,
    required this.bloodType,
    required this.neededDate,
    required this.isUrgent,
    this.additionalInfo,
    this.fileName,
  });
}
