import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:http/http.dart' as http;

final jwtTokenProvider = StateProvider<String?>((ref) => '');

class InterceptorResult<T> {
  final T result;
  InterceptorResult({
    required this.result,
  });
}

class CrezamHTTPInterceptor {
  final String? internalJWTToken;

  CrezamHTTPInterceptor({
    this.internalJWTToken,
  });

  String? get jwtToken => internalJWTToken ?? gpc.read(jwtTokenProvider);

  Future<T?> get<T>(
    String path, {
    bool logResult = false,
    T? successOverride,
    T? failureOverride,
  }) async {
    // log('GET: $path | AT: $jwtToken');
    return await exceptionWrapper<T>(
      method: 'GET',
      path: path,
      request: <T>() async {
        final res = await http.get(Uri.parse(path), headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken'
        });
        return handleInterceptedResponse<T>(
          res,
          path,
          logResult: logResult,
          successOverride: successOverride as T?,
          failureOverride: failureOverride as T?,
        );
      },
    );
  }

  Future<T?> post<T>(
    String path, {
    bool logResult = false,
    T? successOverride,
    T? failureOverride,
    Map? body,
  }) async {
    // log('POST: $path | AT: $jwtToken');
    return await exceptionWrapper<T>(
      path: path,
      method: 'POST',
      request: <T>() async {
        final res = await http.post(
          Uri.parse(path),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
          body: body == null ? null : jsonEncode(body),
        );
        return handleInterceptedResponse<T>(
          res,
          path,
          logResult: logResult,
          successOverride: successOverride as T?,
          failureOverride: failureOverride as T?,
        );
      },
    );
  }

  Future<T?> put<T>(
    String path, {
    bool logResult = false,
    T? successOverride,
    T? failureOverride,
    Map? body,
  }) async {
    // log('PUT: $path | AT: $jwtToken');
    return await exceptionWrapper<T>(
      method: 'PUT',
      path: path,
      request: <T>() async {
        final res = await http.put(
          Uri.parse(path),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
          body: (body == null) ? null : jsonEncode(body),
        );
        return handleInterceptedResponse<T>(
          res,
          path,
          logResult: logResult,
          successOverride: successOverride as T?,
          failureOverride: failureOverride as T?,
        );
      },
    );
  }

  Future<T?> delete<T>(
    String path, {
    bool logResult = false,
    T? successOverride,
    T? failureOverride,
    Map? body,
  }) async {
    // log('DELETE: $path | AT: $jwtToken');
    return await exceptionWrapper<T>(
      method: 'DELETE',
      path: path,
      request: <T>() async {
        final res = await http.delete(
          Uri.parse(path),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
          body: (body == null) ? null : jsonEncode(body),
        );
        return handleInterceptedResponse<T>(
          res,
          path,
          logResult: logResult,
          successOverride: successOverride as T?,
          failureOverride: failureOverride as T?,
        );
      },
    );
  }

  T? handleInterceptedResponse<T>(
    http.Response res,
    String path, {
    bool logResult = false,
    T? successOverride,
    T? failureOverride,
  }) {
    if (res.statusCode == 200 ||
        res.statusCode == 204 ||
        res.statusCode == 201) {
      const utfDecoder = Utf8Decoder();
      final rescontent =
          utfDecoder.convert(res.body.toString().codeUnits).trim();

      if (rescontent.isEmpty) {
        log('[$path] Successful API call but received Empty Response');
        return successOverride;
      }
      dynamic resbody;
      try {
        resbody = jsonDecode(rescontent);
      } on FormatException {
        log('WARN: The Response was not in JSON Format');
        resbody = rescontent;
      } catch (e) {
        logError(
          statusCode: -1,
          method: res.request?.method ?? 'UNKNOWN',
          path: path,
          message: 'Could not parse response',
        );
        return failureOverride;
      }

      if (logResult) {
        print('==== RESULT LOG ====');
        log(resbody.toString());
        print('====================');
      }

      dynamic castedResbody;
      try {
        castedResbody = resbody as T;
      } catch (ex) {
        log('<T>casting unsuccessful => assuming successOverride');
        castedResbody = successOverride;
      }

      return castedResbody;
    } else {
      logError(
        statusCode: res.statusCode,
        method: res.request?.method ?? 'UNKNOWN',
        path: path,
        message: 'None',
      );
      if (logResult) {
        print('==== RESULT LOG ====');
        print(res.body.toString());
        print('====================');
      }
      return failureOverride;
    }
  }

  Future<T?> exceptionWrapper<T>({
    required String path,
    required String method,
    required Future<T?> Function<T>() request,
  }) async {
    try {
      final res = await request();
      return res;
    } catch (e) {
      logError(
        statusCode: 0,
        method: method,
        path: path,
        message: 'Unexpected Exception: $e',
      );
    }
    return null;
  }

  logError({
    required int statusCode,
    required String method,
    required String path,
    required String message,
  }) {
    log('============(SERVER ERROR)===========');
    log('Path: $path');
    log('Method: $method');
    log('StatusCode: $statusCode');
    log('Message: $message');
    // log('AUTHTOKEN => $jwtToken');
    log('=====================================');
  }
}

final interceptor = CrezamHTTPInterceptor();
