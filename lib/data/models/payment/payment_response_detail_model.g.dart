// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponseDetailModel _$PaymentResponseDetailModelFromJson(Map json) =>
    PaymentResponseDetailModel(
      transaction: json['transaction'] as String,
      value: json['value'] as int?,
      status: json['status'] as String?,
      paymentType: json['paymentType'] as int?,
      installments: json['installments'] as int?,
      brand: json['brand'] as String?,
      acquiring: json['acquiring'] as String?,
      sellerName: json['sellerName'] as String?,
      autoCode: json['autoCode'] as String?,
      documentType: json['documentType'] as String?,
      document: json['document'] as String?,
      date: json['date'] as String?,
      hour: json['hour'] as String?,
      sellerReceipt: json['sellerReceipt'] as String?,
      customerReceipt: json['customerReceipt'] as String?,
      approvalMessage: json['approvalMessage'] as String?,
      transactionId: json['transactionId'] as String?,
      address: json['address'] as String?,
      pan: json['pan'] as String?,
      nsu: json['nsu'] as String?,
      cv: json['cv'] as String?,
      arqc: json['arqc'] as String?,
      aid: json['aid'] as String?,
      aidLabel: json['aidLabel'] as String?,
    );

Map<String, dynamic> _$PaymentResponseDetailModelToJson(
        PaymentResponseDetailModel instance) =>
    <String, dynamic>{
      'transaction': instance.transaction,
      'value': instance.value,
      'status': instance.status,
      'paymentType': instance.paymentType,
      'installments': instance.installments,
      'brand': instance.brand,
      'acquiring': instance.acquiring,
      'sellerName': instance.sellerName,
      'autoCode': instance.autoCode,
      'documentType': instance.documentType,
      'document': instance.document,
      'date': instance.date,
      'hour': instance.hour,
      'sellerReceipt': instance.sellerReceipt,
      'customerReceipt': instance.customerReceipt,
      'approvalMessage': instance.approvalMessage,
      'transactionId': instance.transactionId,
      'address': instance.address,
      'pan': instance.pan,
      'nsu': instance.nsu,
      'cv': instance.cv,
      'arqc': instance.arqc,
      'aid': instance.aid,
      'aidLabel': instance.aidLabel,
    };
