// import 'package:injectable/injectable.dart';

// import '../../../../../data/models/base/response.dart';
// import '../../../../../domain/usecase/base/future_use_case.dart';
// import '../../../../../domain/usecase/base/io/input.dart';
// import '../../../../../domain/usecase/base/io/output.dart';
// import '../../domain/repositories/conversation_repository.dart';

// @injectable
// class ContactDetailUseCase
//     extends BaseFutureUseCase<ContactDetailInput, ContactDetailOutput> {
//   ContactDetailUseCase(
//     this._conversationRepository,
//     this._contactMapper,
//   );
//   final ChatRepository _conversationRepository;
//   final ContactEntityMapper _contactMapper;

//   @override
//   Future<ContactDetailOutput> buildUseCase(ContactDetailInput input) async {
//     final res = await _conversationRepository.getContact(input.id);
//     final dataEnitty = _contactMapper.mapToEntity(res.data);
//     return ContactDetailOutput(
//       response: BaseResponseModel(
//         code: res.code,
//         message: res.message,
//         data: dataEnitty,
//       ),
//     );
//   }
// }

// class ContactDetailInput extends BaseInput {
//   final int id;
//   ContactDetailInput({required this.id});
// }

// class ContactDetailOutput extends BaseOutput {
//   final BaseResponseModel<ContactEntity> response;
//   ContactDetailOutput({required this.response});
// }
