import 'dart:convert';

import 'package:flutter_plugin_pos_integration/data/data_sources/pos_data_source.dart';
import 'package:flutter_plugin_pos_integration/data/models/auth/pos_auth_model.dart';
import 'package:flutter_plugin_pos_integration/data/models/payment/payment_response_detail_model.dart';
import 'package:flutter_plugin_pos_integration/data/models/pos_charge/pos_charge_model.dart';
import 'package:flutter_plugin_pos_integration/data/models/pos_device/pos_device_model.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/auth/pos_auth.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:ideploy_package/ideploy_package.dart';

@Injectable(as: PosDataSource)
class PosDataSourceImpl implements PosDataSource {
  @override
  List<PosDevice> getDevices(List<dynamic> data) {
    try {
      return data
          .map(
            (dynamic entry) => PosDeviceModel.fromJson(
              Map<String, dynamic>.from(entry),
            ).toEntity(),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  String deviceToString(PosDevice device) {
    return jsonEncode(PosDeviceModel.fromEntity(device).toJson());
  }

  @override
  String chargeToString(PosCharge charge) {
    return jsonEncode(PosChargeModel.fromEntity(charge).toJson());
  }

  Future<void> _openBox() async {
    if (!Hive.isBoxOpen('pos_integration_box')) {
      await Hive.initFlutter();
      await Hive.openBox('pos_integration_box');
    }
  }

  @override
  Future<PosDevice?> getPairedDevice() async {
    try {
      await _openBox();
      final json = await Hive.box('pos_integration_box').get('paired_device');
      if (json == null) {
        return null;
      }

      return PosDeviceModel.fromJson(Map.from(json)).toEntity();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> pairDevice(PosDevice device) async {
    try {
      await _openBox();
      await Hive.box('pos_integration_box').put('paired_device', PosDeviceModel.fromEntity(device).toJson());
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<PosCredentials?> getCredentials() async {
    try {
      await _openBox();
      final json = await Hive.box('pos_integration_box').get('credentials');
      if (json == null) {
        return null;
      }

      return PosCredentialsModel.fromJson(Map.from(json)).toEntity();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> saveCredentials(Map<String, dynamic> credentials) async {
    try {
      await _openBox();
      final credentialModel = PosCredentialsModel.fromJson(credentials);
      await Hive.box('pos_integration_box').put('credentials', credentialModel.toJson());
    } catch (error) {
      rethrow;
    }
  }

  @override
  PaymentResponse makePaymentResponse(Map<String, dynamic> data) {
    try {
      return PaymentResponse(
        status: PaymentStatusType.success,
        terminalMessage: null,
        details: PaymentResponseDetailModel.fromJson(data).toEntity(),
      );
    } catch (error) {
      rethrow;
    }
  }
}
