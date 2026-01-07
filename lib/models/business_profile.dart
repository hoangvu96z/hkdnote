import 'package:flutter/foundation.dart';

@immutable
class BusinessProfile {
  const BusinessProfile({
    required this.businessName,
    required this.taxCode,
    required this.address,
    required this.taxMethod,
    required this.periodStartDate,
    required this.enableCash,
    required this.enableBank,
  });

  final String businessName;
  final String taxCode;
  final String address;
  final String taxMethod;
  final DateTime periodStartDate;
  final bool enableCash;
  final bool enableBank;
}
