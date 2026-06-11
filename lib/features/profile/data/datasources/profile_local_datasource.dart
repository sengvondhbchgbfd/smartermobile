import 'package:frontendmobile/features/profile/data/models/profile_model.dart';
abstract class ProfileLocalDatasource {
  Future<ProfileModel> getProfile();
}
