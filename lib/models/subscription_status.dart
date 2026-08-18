class SubscriptionStatus {
  final String status; // 'active', 'expired', 'canceled', 'none'
  final DateTime? startDate;
  final DateTime? endDate;
  final String? productId;
  final String? platform; // 'android' or 'ios'
  final DateTime? lastVerification;

  SubscriptionStatus({
    required this.status,
    this.startDate,
    this.endDate,
    this.productId,
    this.platform,
    this.lastVerification,
  });

  bool get isActive {
    if (status != 'active') return false;
    if (endDate == null) return true;
    // Adiciona 3 dias de tolerância para processamento de renovação da loja
    final graceEndDate = endDate!.add(const Duration(days: 3));
    return graceEndDate.isAfter(DateTime.now());
  }

  bool get isExpired {
    if (endDate == null) return false;
    final graceEndDate = endDate!.add(const Duration(days: 3));
    return graceEndDate.isBefore(DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'productId': productId,
      'platform': platform,
      'lastVerification': lastVerification?.toIso8601String(),
    };
  }

  factory SubscriptionStatus.fromMap(Map<String, dynamic> map) {
    return SubscriptionStatus(
      status: map['status'] ?? 'none',
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate:
          map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      productId: map['productId'],
      platform: map['platform'],
      lastVerification: map['lastVerification'] != null
          ? DateTime.parse(map['lastVerification'])
          : null,
    );
  }

  factory SubscriptionStatus.none() {
    return SubscriptionStatus(status: 'none');
  }
}

