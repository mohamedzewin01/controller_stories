import 'Stories_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoriesDatasourceRepo)
class StoriesDatasourceRepoImpl implements StoriesDatasourceRepo {
  final ApiService apiService;
  StoriesDatasourceRepoImpl(this.apiService);
}
