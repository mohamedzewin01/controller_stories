import 'AudioName_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: AudioNameDatasourceRepo)
class AudioNameDatasourceRepoImpl implements AudioNameDatasourceRepo {
  final ApiService apiService;
  AudioNameDatasourceRepoImpl(this.apiService);
}
