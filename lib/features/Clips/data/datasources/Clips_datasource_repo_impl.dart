import 'Clips_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ClipsDatasourceRepo)
class ClipsDatasourceRepoImpl implements ClipsDatasourceRepo {
  final ApiService apiService;
  ClipsDatasourceRepoImpl(this.apiService);
}
