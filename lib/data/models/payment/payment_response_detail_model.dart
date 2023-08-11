import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response_detail.dart';
import 'package:ideploy_package/ideploy_package.dart';

part 'payment_response_detail_model.g.dart';
part 'payment_response_detail_model.mapper.dart';

@JsonSerializable(anyMap: true)
class PaymentResponseDetailModel extends PaymentResponseDetail {
  PaymentResponseDetailModel({
    required String transaction,
    int? value,
    String? status,
    int? paymentType,
    int? installments,
    String? brand,
    String? acquiring,
    String? sellerName,
    String? autoCode,
    String? documentType,
    String? document,
    String? date,
    String? hour,
    String? sellerReceipt,
    String? customerReceipt,
    String? approvalMessage,
    String? transactionId,
    String? address,
    String? pan,
    String? nsu,
    String? cv,
    String? arqc,
    String? aid,
    String? aidLabel,
  }) : super(
          transaction: transaction,
          value: value,
          status: status,
          paymentType: paymentType,
          installments: installments,
          brand: brand,
          acquiring: acquiring,
          sellerName: sellerName,
          autoCode: autoCode,
          documentType: documentType,
          document: document,
          date: date,
          hour: hour,
          sellerReceipt: sellerReceipt,
          customerReceipt: customerReceipt,
          approvalMessage: approvalMessage,
          transactionId: transactionId,
          address: address,
          pan: pan,
          nsu: nsu,
          cv: cv,
          arqc: arqc,
          aid: aid,
          aidLabel: aidLabel,
        );

  factory PaymentResponseDetailModel.fromJson(Map<String, dynamic> json) => _$PaymentResponseDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResponseDetailModelToJson(this);

  factory PaymentResponseDetailModel.fromEntity(PaymentResponseDetail entity) =>
      _$PaymentResponseDetailModelFromEntity(entity);
  PaymentResponseDetail toEntity() => _$PaymentResponseDetailModelToEntity(this);
}
