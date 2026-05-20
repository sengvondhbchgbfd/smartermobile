import 'package:frontendmobile/core/storage/secure_storage_service.dart';
import 'package:frontendmobile/features/profile/data/models/profile_model.dart';
import 'profile_local_datasource.dart';

class ProfileLocalDatasourceImpl implements ProfileLocalDatasource {
  final SecureStorageService _storage;
  ProfileLocalDatasourceImpl(this._storage);

  @override
  Future<ProfileModel> getProfile() async {
    final user = await _storage.getUserInfo();
    if (user == null) throw Exception('No user info found');
    return ProfileModel.fromUserInfo(user);
  }
}