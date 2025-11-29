import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

/// Use case for saving contacts
class SaveContactUseCase extends UseCase<bool, SaveContactParams> {
  final ContactRepository repository;

  SaveContactUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveContactParams params) async {
    return await repository.saveContact(params.contact);
  }
}

/// Parameters for saving a contact
class SaveContactParams extends Equatable {
  final ContactEntity contact;

  const SaveContactParams({required this.contact});

  @override
  List<Object?> get props => [contact];
}
