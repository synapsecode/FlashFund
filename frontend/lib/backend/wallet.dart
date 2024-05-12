import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/backend.dart';
import 'package:frontend/backend/interceptor.dart';
import 'package:frontend/main.dart';

final currentWalletBalance = StateProvider<double>((ref) => 0);

class VirtualWallet {
  static deposit({
    required String type,
    required int amount,
    required int id,
  }) async {
    final res = await interceptor.post(
      '$SERVER/wallet_deposit/$type/$id/$amount',
    );
    if (res == null) {
      print('Some Error Occured!');
      return;
    }
    final balance = res['balance'];
    if (balance == null) {
      print('No Balance Found');
      return;
    }
    gpc.read(currentWalletBalance.notifier).state = balance;
  }

  static withdraw({
    required String type,
    required int amount,
    required int id,
  }) async {
    final res = await interceptor.post(
      '$SERVER/wallet_withdraw/$type/$id/$amount',
    );
    if (res == null) {
      print('Some Error Occured!');
      return;
    }
    final balance = res['balance'];
    if (balance == null) {
      print('No Balance Found');
      return;
    }
    gpc.read(currentWalletBalance.notifier).state = balance;
  }

  static Future<double?> getBalance({
    required String type,
    required int id,
  }) async {
    final res = await interceptor.post(
      '$SERVER/get_wallet_balance/$type/$id',
    );
    if (res == null) {
      print('Something Went Wrong!');
      return null;
    }
    final balance = res['balance'];
    if (balance == null) {
      print('No Balance Found');
      return null;
    }
    print("$type Fetched Balance => $balance");
    gpc.read(currentWalletBalance.notifier).state = balance;
    return balance;
  }
}
