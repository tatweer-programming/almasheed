import 'package:almasheed/main/data/data_source/main_remote_data_source.dart';
import 'package:get_it/get_it.dart';

import '../../main/bloc/main_bloc.dart';
import '../../main/data/repositories/main_repository.dart';


final sl = GetIt.instance;

class ServiceLocator {
  void init() async {
    /// bloc
    MainBloc mainBloc = MainBloc(MainInitial());
    sl.registerLazySingleton(() => mainBloc);

    /// main
    MainRemoteDataSource mainRemoteDataSource = MainRemoteDataSource();
    sl.registerLazySingleton(() => mainRemoteDataSource);

    MainRepository mainRepository = MainRepository(sl());
    sl.registerLazySingleton(() => mainRepository);
  }
}
