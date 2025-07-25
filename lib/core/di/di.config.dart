// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/AudioName/data/datasources/AudioName_datasource_repo.dart'
    as _i454;
import '../../features/AudioName/data/datasources/AudioName_datasource_repo_impl.dart'
    as _i861;
import '../../features/AudioName/data/repositories_impl/AudioName_repo_impl.dart'
    as _i486;
import '../../features/AudioName/domain/repositories/AudioName_repository.dart'
    as _i337;
import '../../features/AudioName/domain/useCases/AudioName_useCase_repo.dart'
    as _i242;
import '../../features/AudioName/domain/useCases/AudioName_useCase_repo_impl.dart'
    as _i576;
import '../../features/AudioName/presentation/bloc/AudioName_cubit.dart'
    as _i378;
import '../../features/Categories/data/datasources/Categories_datasource_repo.dart'
    as _i304;
import '../../features/Categories/data/datasources/Categories_datasource_repo_impl.dart'
    as _i138;
import '../../features/Categories/data/repositories_impl/Categories_repo_impl.dart'
    as _i541;
import '../../features/Categories/domain/repositories/Categories_repository.dart'
    as _i208;
import '../../features/Categories/domain/useCases/Categories_useCase_repo.dart'
    as _i361;
import '../../features/Categories/domain/useCases/Categories_useCase_repo_impl.dart'
    as _i151;
import '../../features/Categories/presentation/bloc/Categories_cubit.dart'
    as _i643;
import '../../features/Clips/data/datasources/Clips_datasource_repo.dart'
    as _i1051;
import '../../features/Clips/data/datasources/Clips_datasource_repo_impl.dart'
    as _i467;
import '../../features/Clips/data/repositories_impl/Clips_repo_impl.dart'
    as _i1053;
import '../../features/Clips/domain/repositories/Clips_repository.dart'
    as _i444;
import '../../features/Clips/domain/useCases/Clips_useCase_repo.dart' as _i380;
import '../../features/Clips/domain/useCases/Clips_useCase_repo_impl.dart'
    as _i847;
import '../../features/Clips/presentation/bloc/Clips_cubit.dart' as _i92;
import '../../features/Home/data/datasources/Home_datasource_repo.dart'
    as _i827;
import '../../features/Home/data/datasources/Home_datasource_repo_impl.dart'
    as _i97;
import '../../features/Home/data/repositories_impl/Home_repo_impl.dart' as _i60;
import '../../features/Home/domain/repositories/Home_repository.dart' as _i126;
import '../../features/Home/domain/useCases/Home_useCase_repo.dart' as _i543;
import '../../features/Home/domain/useCases/Home_useCase_repo_impl.dart'
    as _i557;
import '../../features/Home/presentation/bloc/Home_cubit.dart' as _i371;
import '../../features/Problems/data/datasources/Problems_datasource_repo.dart'
    as _i1027;
import '../../features/Problems/data/datasources/Problems_datasource_repo_impl.dart'
    as _i663;
import '../../features/Problems/data/repositories_impl/Problems_repo_impl.dart'
    as _i507;
import '../../features/Problems/domain/repositories/Problems_repository.dart'
    as _i854;
import '../../features/Problems/domain/useCases/Problems_useCase_repo.dart'
    as _i741;
import '../../features/Problems/domain/useCases/Problems_useCase_repo_impl.dart'
    as _i29;
import '../../features/Problems/presentation/bloc/Problems_cubit.dart' as _i508;
import '../../features/RequestStory/data/datasources/RequestStory_datasource_repo.dart'
    as _i22;
import '../../features/RequestStory/data/datasources/RequestStory_datasource_repo_impl.dart'
    as _i596;
import '../../features/RequestStory/data/repositories_impl/RequestStory_repo_impl.dart'
    as _i168;
import '../../features/RequestStory/domain/repositories/RequestStory_repository.dart'
    as _i709;
import '../../features/RequestStory/domain/useCases/RequestStory_useCase_repo.dart'
    as _i425;
import '../../features/RequestStory/domain/useCases/RequestStory_useCase_repo_impl.dart'
    as _i938;
import '../../features/RequestStory/presentation/bloc/RequestStory_cubit.dart'
    as _i782;
import '../../features/Stories/data/datasources/Stories_datasource_repo.dart'
    as _i1073;
import '../../features/Stories/data/datasources/Stories_datasource_repo_impl.dart'
    as _i256;
import '../../features/Stories/data/repositories_impl/Stories_repo_impl.dart'
    as _i166;
import '../../features/Stories/domain/repositories/Stories_repository.dart'
    as _i55;
import '../../features/Stories/domain/useCases/Stories_useCase_repo.dart'
    as _i891;
import '../../features/Stories/domain/useCases/Stories_useCase_repo_impl.dart'
    as _i809;
import '../../features/Stories/presentation/bloc/Stories_cubit.dart' as _i879;
import '../api/api_manager/api_manager.dart' as _i680;
import '../api/dio_module.dart' as _i784;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.lazySingleton<_i361.Dio>(() => dioModule.providerDio());
    gh.factory<_i126.HomeRepository>(() => _i60.HomeRepositoryImpl());
    gh.factory<_i680.ApiService>(() => _i680.ApiService(gh<_i361.Dio>()));
    gh.factory<_i827.HomeDatasourceRepo>(
      () => _i97.HomeDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i304.CategoriesDatasourceRepo>(
      () => _i138.CategoriesDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i1051.ClipsDatasourceRepo>(
      () => _i467.ClipsDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i22.RequestStoryDatasourceRepo>(
      () => _i596.RequestStoryDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i543.HomeUseCaseRepo>(
      () => _i557.HomeUseCase(gh<_i126.HomeRepository>()),
    );
    gh.factory<_i208.CategoriesRepository>(
      () =>
          _i541.CategoriesRepositoryImpl(gh<_i304.CategoriesDatasourceRepo>()),
    );
    gh.factory<_i1073.StoriesDatasourceRepo>(
      () => _i256.StoriesDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i371.HomeCubit>(
      () => _i371.HomeCubit(gh<_i543.HomeUseCaseRepo>()),
    );
    gh.factory<_i454.AudioNameDatasourceRepo>(
      () => _i861.AudioNameDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i709.RequestStoryRepository>(
      () => _i168.RequestStoryRepositoryImpl(
        gh<_i22.RequestStoryDatasourceRepo>(),
      ),
    );
    gh.factory<_i361.CategoriesUseCaseRepo>(
      () => _i151.CategoriesUseCase(gh<_i208.CategoriesRepository>()),
    );
    gh.factory<_i1027.ProblemsDatasourceRepo>(
      () => _i663.ProblemsDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i444.ClipsRepository>(
      () => _i1053.ClipsRepositoryImpl(gh<_i1051.ClipsDatasourceRepo>()),
    );
    gh.factory<_i425.RequestStoryUseCaseRepo>(
      () => _i938.RequestStoryUseCase(gh<_i709.RequestStoryRepository>()),
    );
    gh.factory<_i337.AudioNameRepository>(
      () => _i486.AudioNameRepositoryImpl(gh<_i454.AudioNameDatasourceRepo>()),
    );
    gh.factory<_i854.ProblemsRepository>(
      () => _i507.ProblemsRepositoryImpl(gh<_i1027.ProblemsDatasourceRepo>()),
    );
    gh.factory<_i782.RequestStoryCubit>(
      () => _i782.RequestStoryCubit(gh<_i425.RequestStoryUseCaseRepo>()),
    );
    gh.factory<_i242.AudioNameUseCaseRepo>(
      () => _i576.AudioNameUseCase(gh<_i337.AudioNameRepository>()),
    );
    gh.factory<_i378.AudioNameCubit>(
      () => _i378.AudioNameCubit(gh<_i242.AudioNameUseCaseRepo>()),
    );
    gh.factory<_i55.StoriesRepository>(
      () => _i166.StoriesRepositoryImpl(gh<_i1073.StoriesDatasourceRepo>()),
    );
    gh.factory<_i380.ClipsUseCaseRepo>(
      () => _i847.ClipsUseCase(gh<_i444.ClipsRepository>()),
    );
    gh.factory<_i643.CategoriesCubit>(
      () => _i643.CategoriesCubit(gh<_i361.CategoriesUseCaseRepo>()),
    );
    gh.factory<_i891.StoriesUseCaseRepo>(
      () => _i809.StoriesUseCase(gh<_i55.StoriesRepository>()),
    );
    gh.factory<_i741.ProblemsUseCaseRepo>(
      () => _i29.ProblemsUseCase(gh<_i854.ProblemsRepository>()),
    );
    gh.factory<_i92.ClipsCubit>(
      () => _i92.ClipsCubit(gh<_i380.ClipsUseCaseRepo>()),
    );
    gh.factory<_i879.StoriesCubit>(
      () => _i879.StoriesCubit(gh<_i891.StoriesUseCaseRepo>()),
    );
    gh.factory<_i508.ProblemsCubit>(
      () => _i508.ProblemsCubit(gh<_i741.ProblemsUseCaseRepo>()),
    );
    return this;
  }
}

class _$DioModule extends _i784.DioModule {}
