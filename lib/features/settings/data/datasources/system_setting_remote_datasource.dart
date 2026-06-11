import 'package:dio/dio.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import '../models/system_setting_model.dart';

// ---------------------------------------------------------------------------
// Abstract
// ---------------------------------------------------------------------------

abstract class SystemSettingRemoteDataSource {
  Future<List<SystemSettingModel>> getAll();
  Future<SystemSettingModel> getById(int settingId);
  Future<SystemSettingModel> getByKey(String key);
  Future<SystemSettingModel> create({
    required String key,
    required String value,
    String? description,
  });
  Future<SystemSettingModel> updateById({
    required int settingId,
    required String value,
    String? description,
  });
  Future<SystemSettingModel> upsertByKey({
    required String key,
    required String value,
  });
  Future<List<SystemSettingModel>> bulkUpsert(
    List<({String key, String value})> items,
  );
  Future<void> delete(int settingId);
}

// ---------------------------------------------------------------------------
// Implementation — uses your DioClient (AuthInterceptor handles token)
// ---------------------------------------------------------------------------

class SystemSettingRemoteDataSourceImpl
    implements SystemSettingRemoteDataSource {
  final DioClient _dioClient;

  // endpoint prefix — matches your FastAPI router prefix="/system-settings"
  static const _path = '/system-settings';

  SystemSettingRemoteDataSourceImpl(this._dioClient);

  Dio get _dio => _dioClient.dio;

  // ── helpers ───────────────────────────────────────────────────────────────

  /// Unwrap Dio response and cast to T.
  T _data<T>(Response res) => res.data as T;

  /// Map DioException → ApiException with your backend's detail message.
  Never _throw(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final detail = e.response?.data;
    final message = detail is Map
        ? (detail['detail'] ?? e.message ?? 'Unknown error').toString()
        : e.message ?? 'Unknown error';
    throw ApiException(statusCode: statusCode, message: message);
  }

  // ── GET all ──────────────────────────────────────────────────────────────

  @override
  Future<List<SystemSettingModel>> getAll() async {
    try {
      final res = await _dio.get(_path);
      return (_data<List>(
        res,
      )).map((e) => SystemSettingModel.fromJson(e)).toList();
    } on DioException catch (e) {
      _throw(e);
    }
  }

  // ── GET by id ─────────────────────────────────────────────────────────────

  @override
  Future<SystemSettingModel> getById(int settingId) async {
    try {
      final res = await _dio.get('$_path/$settingId');
      return SystemSettingModel.fromJson(_data(res));
    } on DioException catch (e) {
      _throw(e);
    }
  }

  // ── GET by key ────────────────────────────────────────────────────────────

  @override
  Future<SystemSettingModel> getByKey(String key) async {
    try {
      final res = await _dio.get('$_path/key/$key');
      return SystemSettingModel.fromJson(_data(res));
    } on DioException catch (e) {
      _throw(e);
    }
  }

  // ── CREATE ────────────────────────────────────────────────────────────────

  @override
  Future<SystemSettingModel> create({
    required String key,
    required String value,
    String? description,
  }) async {
    try {
      final res = await _dio.post(
        _path,
        data: {
          'key': key,
          'value': value,
          if (description != null) 'description': description,
        },
      );
      return SystemSettingModel.fromJson(_data(res));
    } on DioException catch (e) {
      _throw(e);
    }
  }

  // ── UPDATE by id ──────────────────────────────────────────────────────────

  @override
  Future<SystemSettingModel> updateById({
    required int settingId,
    required String value,
    String? description,
  }) async {
    try {
      final res = await _dio.patch(
        '$_path/$settingId',
        data: {
          'value': value,
          if (description != null) 'description': description,
        },
      );
      return SystemSettingModel.fromJson(_data(res));
    } on DioException catch (e) {
      _throw(e);
    }
  }

  // ── UPSERT by key ─────────────────────────────────────────────────────────

  @override
  Future<SystemSettingModel> upsertByKey({
    required String key,
    required String value,
  }) async {
    try {
      final res = await _dio.patch('$_path/key/$key', data: {'value': value});
      return SystemSettingModel.fromJson(_data(res));
    } on DioException catch (e) {
      _throw(e);
    }
  }

  // ── BULK upsert ───────────────────────────────────────────────────────────

  @override
  Future<List<SystemSettingModel>> bulkUpsert(
    List<({String key, String value})> items,
  ) async {
    try {
      final res = await _dio.patch(
        '$_path/bulk',
        data: {
          'settings': items
              .map((e) => {'key': e.key, 'value': e.value})
              .toList(),
        },
      );
      final updated = (_data<Map>(res))['updated'] as List;
      return updated.map((e) => SystemSettingModel.fromJson(e)).toList();
    } on DioException catch (e) {
      _throw(e);
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────────────

  @override
  Future<void> delete(int settingId) async {
    try {
      await _dio.delete('$_path/$settingId');
    } on DioException catch (e) {
      _throw(e);
    }
  }
}

// ---------------------------------------------------------------------------
// Exception
// ---------------------------------------------------------------------------

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
