import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/features/booking_contracts_payments/domain/entities/contract_entity.dart';
import 'package:MARN/core/widgets/buildImage_url.dart';

class CreateAndSignContractModel extends CreateAndSignContractEntity {
  CreateAndSignContractModel({required super.message, required super.id});

  factory CreateAndSignContractModel.fromJson(Map<String, dynamic> json) {
    return CreateAndSignContractModel(
      message: json['message'],
      id: json['data'],
    );
  }
}

class ContractDetailsModel extends ContractDetailsEntity {
  ContractDetailsModel({
    required super.contractStatus,
    super.transactionId,
    super.merkleRoot,
    required super.anchoringStatus,
    required super.isAnchoredToBlockChain,
    required super.contractId,
    required super.duration,
    super.startDate,
    super.endDate,
    required super.totalContractValue,
    required super.propertyInfo,
    required super.ownerInfo,
    required super.renterInfo,
  });

  factory ContractDetailsModel.fromJson(Map<String, dynamic> json) {
    return ContractDetailsModel(
      contractStatus: EnumItem.resolve(
        EnumType.contractStatuses,
        json['contractStatus'],
      ),
      transactionId: json['transactionId'],
      merkleRoot: json['merkleRoot'],
      anchoringStatus: EnumItem.resolve(
        EnumType.contractAnchoringStatuses,
        json['anchoringStatus'],
      ),
      isAnchoredToBlockChain: json['isAnchoredToBlockChain'] ?? false,
      contractId: json['contractId'],
      duration: json['duration'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      totalContractValue: json['totalContractValue'],
      propertyInfo: ContractPropertyInfoModel.fromJson(json['propertyInfo']),
      ownerInfo: ContractUserInfoModel.fromJson(json['ownerInfo']),
      renterInfo: ContractUserInfoModel.fromJson(json['renterInfo']),
    );
  }
}

class ContractPropertyInfoModel extends ContractPropertyInfoEntity {
  ContractPropertyInfoModel({
    required super.id,
    required super.name,
    required super.streetAddress,
    required super.city,
    required super.governorate,
    required super.rentalDuration,
    required super.price,
  });

  factory ContractPropertyInfoModel.fromJson(Map<String, dynamic> json) {
    return ContractPropertyInfoModel(
      id: json['id'],
      name: json['name'],
      streetAddress: json['streetAddress'],
      city: json['city'],
      governorate: EnumItem.resolve(
        EnumType.governorates,
        json['governorate'],
      ),
      rentalDuration: json['rentalDuration'],
      price: json['price'],
    );
  }
}

class ContractUserInfoModel extends ContractUserInfoEntity {
  ContractUserInfoModel({
    required super.id,
    super.profileImage,
    required super.fullName,
    required super.email,
  });

  factory ContractUserInfoModel.fromJson(Map<String, dynamic> json) {
    return ContractUserInfoModel(
      id: json['id'],
      profileImage: buildImageUrl(json['profileImage']),
      fullName: json['fullName'],
      email: json['email'],
    );
  }
}

class ContractProofVerificationModel extends ContractProofVerificationEntity {
  ContractProofVerificationModel({
    required super.match,
    required super.message,
    required super.status,
    required super.anchoringStatus,
    super.anchoredAt,
  });

  factory ContractProofVerificationModel.fromJson(Map<String, dynamic> json) {
    return ContractProofVerificationModel(
      match: json['match'],
      message: json['message'],
      status: EnumItem.resolve(EnumType.contractStatuses, json['status']),
      anchoringStatus: EnumItem.resolve(
        EnumType.contractAnchoringStatuses,
        json['anchoringStatus'],
      ),
      anchoredAt: json['anchoredAt'] != null ? DateTime.parse(json['anchoredAt']) : null,
    );
  }
}
