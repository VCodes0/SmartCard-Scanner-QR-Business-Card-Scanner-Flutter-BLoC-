import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/save_contact_usecase.dart';
import 'contact_event.dart';
import 'contact_state.dart';

/// BLoC for handling contact operations
class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final SaveContactUseCase saveContact;

  ContactBloc({required this.saveContact}) : super(const ContactInitial()) {
    on<SaveContactEvent>(_onSaveContact);
    on<ResetContactEvent>(_onResetContact);
  }

  Future<void> _onSaveContact(
    SaveContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(const ContactSaving());

    final result = await saveContact(SaveContactParams(contact: event.contact));

    result.fold(
      (failure) => emit(ContactError(failure.message)),
      (success) => emit(const ContactSaved()),
    );
  }

  Future<void> _onResetContact(
    ResetContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(const ContactInitial());
  }
}
