import 'Home_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: HomeDatasourceRepo)
class HomeDatasourceRepoImpl implements HomeDatasourceRepo {
  final ApiService apiService;
  HomeDatasourceRepoImpl(this.apiService);
}
