import 'package:frontend/backend/auth.dart';
import 'package:frontend/backend/backend.dart';
import 'package:frontend/backend/interceptor.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/investor/currentroadshows.dart';

class RoadshowBackend {
  static Future<bool> createRoadshow({
    required int projectedValuation,
    required int loanAmount,
  }) async {
    final bid = gpc.read(businessUserIDProvider)!;
    final body = {
      "business_id": bid,
      "valuation": projectedValuation,
      "loan_amount": loanAmount,
    };
    final res = await interceptor.post(
      '$SERVER/business/create_roadshow',
      body: body,
    );
    if (res == null) {
      return false;
    }
    return true;
  }

  static Future<List?> getAllRoadshows() async {
    final res = await interceptor.get('$SERVER/investor/roadshows');
    if (res == null) return null;
    final roadshows =
        (res['roadshows']!).map((x) => RoadshowModel.fromMap(x)).toList();
    return roadshows;
  }

  static Future<List?> getAllIPOs() async {
    final res = await interceptor.get('$SERVER/investor/all_ipos');
    if (res == null) return null;
    final ipos = (res['ipos']!).map((x) => RoadshowModel.fromMap(x)).toList();
    return ipos;
  }
}
