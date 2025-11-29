import 'package:get_it/get_it.dart';
import '../../data/datasources/contact_data_source.dart';
import '../../data/datasources/scanner_data_source.dart';
import '../../data/repositories/contact_repository_impl.dart';
import '../../data/repositories/scanner_repository_impl.dart';
import '../../domain/repositories/contact_repository.dart';
import '../../domain/repositories/scanner_repository.dart';
import '../../domain/usecases/save_contact_usecase.dart';
import '../../domain/usecases/scan_business_card_usecase.dart';
import '../../domain/usecases/scan_qr_code_usecase.dart';
import '../../presentation/bloc/contact/contact_bloc.dart';
import '../../presentation/bloc/scanner/scanner_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Scanner & Contact

  // Bloc
  sl.registerFactory(
    () => ScannerBloc(scanQRCode: sl(), scanBusinessCard: sl()),
  );

  sl.registerFactory(() => ContactBloc(saveContact: sl()));

  // Use cases
  sl.registerLazySingleton(() => ScanQRCodeUseCase(sl()));
  sl.registerLazySingleton(() => ScanBusinessCardUseCase(sl()));
  sl.registerLazySingleton(() => SaveContactUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ScannerRepository>(
    () => ScannerRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ScannerDataSource>(() => ScannerDataSourceImpl());

  sl.registerLazySingleton<ContactDataSource>(() => ContactDataSourceImpl());
}
