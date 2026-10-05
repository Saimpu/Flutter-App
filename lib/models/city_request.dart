class CityRequest {
  const CityRequest({
    required this.reference,
    required this.serviceTitle,
    required this.details,
    required this.createdAt,
  });

  final String reference;
  final String serviceTitle;
  final String details;
  final DateTime createdAt;
}
