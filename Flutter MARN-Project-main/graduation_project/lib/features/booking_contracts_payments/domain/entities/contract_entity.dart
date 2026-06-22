import 'package:MARN/core/enums/models/enum_item.dart';

abstract class CreateAndSignContractEntity {
  String message;
  int id;

  CreateAndSignContractEntity({required this.message, required this.id});
}

abstract class ContractDetailsEntity {
  final EnumItem contractStatus;
  final String? transactionId;
  final String? merkleRoot;
  final EnumItem anchoringStatus;
  final bool isAnchoredToBlockChain;
  final int contractId;
  final String duration;
  final DateTime? startDate;
  final DateTime? endDate;
  final num totalContractValue;
  final ContractPropertyInfoEntity propertyInfo;
  final ContractUserInfoEntity ownerInfo;
  final ContractUserInfoEntity renterInfo;

  ContractDetailsEntity({
    required this.contractStatus,
    this.transactionId,
    this.merkleRoot,
    required this.anchoringStatus,
    required this.isAnchoredToBlockChain,
    required this.contractId,
    required this.duration,
    this.startDate,
    this.endDate,
    required this.totalContractValue,
    required this.propertyInfo,
    required this.ownerInfo,
    required this.renterInfo,
  });
}

abstract class ContractPropertyInfoEntity {
  final int id;
  final String name;
  final String streetAddress;
  final String city;
  final EnumItem governorate;
  final String rentalDuration;
  final num price;

  ContractPropertyInfoEntity({
    required this.id,
    required this.name,
    required this.streetAddress,
    required this.city,
    required this.governorate,
    required this.rentalDuration,
    required this.price,
  });
}

abstract class ContractUserInfoEntity {
  final String id;
  final String? profileImage;
  final String fullName;
  final String email;

  ContractUserInfoEntity({
    required this.id,
    this.profileImage,
    required this.fullName,
    required this.email,
  });
}

abstract class ContractProofVerificationEntity {
  final bool match;
  final String message;
  final EnumItem status;
  final EnumItem anchoringStatus;
  final DateTime? anchoredAt;

  ContractProofVerificationEntity({
    required this.match,
    required this.message,
    required this.status,
    required this.anchoringStatus,
    this.anchoredAt,
  });
}
