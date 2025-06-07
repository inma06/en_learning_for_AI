// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/news/data/datasources/news_remote_datasource.dart'
    as _i173;
import '../../features/news/data/repositories/news_repository_impl.dart'
    as _i164;
import '../../features/news/domain/repositories/news_repository.dart' as _i258;
import '../../features/news/domain/usecases/get_questions.dart' as _i415;
import '../../features/news/domain/usecases/submit_answer.dart' as _i362;
import '../../features/news/presentation/bloc/news_bloc.dart' as _i476;
import '../local_storage/hive_service.dart' as _i764;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i764.HiveService>(() => _i764.HiveService());
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i932.NetworkInfo>(() => _i932.NetworkInfoImpl());
    gh.lazySingleton<_i173.NewsRemoteDataSource>(
        () => _i173.NewsRemoteDataSourceImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i258.NewsRepository>(() => _i164.NewsRepositoryImpl(
          remoteDataSource: gh<_i173.NewsRemoteDataSource>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i415.GetQuestions>(
        () => _i415.GetQuestions(gh<_i258.NewsRepository>()));
    gh.lazySingleton<_i362.SubmitAnswer>(
        () => _i362.SubmitAnswer(gh<_i258.NewsRepository>()));
    gh.factory<_i476.NewsBloc>(() => _i476.NewsBloc(
          gh<_i415.GetQuestions>(),
          gh<_i362.SubmitAnswer>(),
        ));
    return this;
  }
}
