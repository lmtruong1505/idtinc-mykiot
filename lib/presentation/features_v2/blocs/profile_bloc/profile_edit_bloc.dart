import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/address/data/models/district_model.dart';
import 'package:pharmago/presentation/features/address/data/models/province_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/profile/profile_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../data/models/base/response.dart';
import '../../../../shared/utils/delay_callback.dart';
import '../../../features/address/data/models/address_model.dart';
import '../../../features/address/data/models/ward_model.dart';
import '../../../features/address/domain/entities/address_item_entity.dart';
import '../../../features/company/domain/entities/bank_entity.dart';
import '../../../features/company/domain/usecase/get_acc_name_bank_use_case.dart';
import '../../../features/company/domain/usecase/list_bank_use_case.dart';
import '../../repositories/profile/profile_repository.dart';
import '../enum/bloc_status.dart';

@injectable
class ProfileEditBloc extends Cubit<CubitState> {
  ProfileEditBloc(this._listBankUseCase, this._getAccNameBankUseCase)
      : super(CubitState());

  final _repo = ProfileRepository();
  final ListBankUseCase _listBankUseCase;
  ProfileModel? model;
  BankEntity? _bank;

  BankEntity? get bank => _bank;

  void setBank(BankEntity? value) {
    _bank = value;
    print('bank: ${bank?.toJson()}');
    emit(state.copyWith(status: BlocStatus.success));
  }

  String? _userBankName;

  void setBankName(String? value) {
    _userBankName = value;
    if (value != null && value.isNotEmpty) {
      getNameAcc();
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  String? get userBankName => _userBankName;
  String? _userBankNumber;

  void setBankNumber(String? value) {
    _userBankNumber = value;
    if (value != null && value.isNotEmpty) {
      getNameAcc();
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  String? get userBankNumber => _userBankNumber;
  List<BankEntity> banks = [];
  final DelayCallBack delayCallBack = DelayCallBack(delay: 500.milliseconds);
  final GetAccNameBankUseCase _getAccNameBankUseCase;

  Future<void> init(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getProfile();
    if (res.code == 200) {
      model = res.data;
      _userBankName = model?.accountName;
      _userBankNumber = model?.accountNumber;
      await getBanks(id: model?.bank?.id);
      emit(state.copyWith(status: BlocStatus.success));
    } else {
      emit(state.copyWith(status: BlocStatus.failure, msg: res.message));
    }
  }

  Future<void> getBanks({
    int? id,
  }) async {
    final res = await _listBankUseCase.execute(ListBankInput());
    final banksT = res.response.data ?? [];
    final bankT = banksT.firstWhereOrNull((element) => element.id == id);
    _bank = bankT;
    banks = banksT;
    if (userBankName != null && userBankName!.isNotEmpty) {
      getNameAcc();
    }
  }

  void getNameAcc() {
    if (_userBankNumber != null && bank != null) {
      final input = GetAccNameBankInput(
        accountNumber: _userBankNumber!,
        bank: bank!.id ?? 0,
      );
      delayCallBack.debounce(() {
        _getAccNameBankUseCase.execute(input).then((value) {
          if (value.response.data != null) {
            _userBankName = value.response.data;
            return;
          } else {
            _userBankName = '';
            return;
          }
        });
      });
    }
  }

  void changeInfo({
    String? name,
    String? phone,
    String? gender,
    String? email,
    DateTime? dob,
    String? taxNumber,
    String? faxNumber,
    String? website,
  }) {
    if (model == null) return;
    model = model!.copyWith(
      fullName: name ?? model!.fullName,
      phoneNumber: phone ?? model!.phoneNumber,
      gender: gender ?? model!.gender,
      email: email ?? model!.email,
      dateOfBirth: dob ?? model!.dateOfBirth,
      taxNumber: taxNumber ?? model!.taxNumber,
      faxNumber: faxNumber ?? model!.faxNumber,
      website: website ?? model!.website,
    );
    emit(state.copyWith(status: BlocStatus.success));
  }

  void updateAddress({
    String? detail,
    AddressItemEntity? district,
    AddressItemEntity? province,
    AddressItemEntity? ward,
  }) {
    final districtModel = DistrictModel(
      code: district?.code,
      name: district?.name,
      nameEn: district?.nameEn,
    );
    final provinceModel = ProvinceModel(
      code: province?.code,
      name: province?.name,
      nameEn: province?.nameEn,
    );
    final wardModel = WardModel(
      code: ward?.code,
      name: ward?.name,
      nameEn: ward?.nameEn,
    );

    final addressModel = AddressModel(
      id: model?.address?.id,
      lat: model?.address?.lat,
      lng: model?.address?.lng,
      province: provinceModel,
      district: districtModel,
      ward: wardModel,
      title: detail,
    );

    print('====> addressModel: ${addressModel.toJson()}');

    model = model!.copyWith(address: addressModel);
    emit(state.copyWith(status: BlocStatus.success));
  }

  void changeCCCD({
    String? identifyNumber,
    DateTime? providedDate,
    String? providedPlace,
  }) {
    if (model == null) return;
    model = model!.copyWith(
      identifyNumber: identifyNumber ?? model!.identifyNumber,
      providedDate: providedDate ?? model!.providedDate,
      providedPlace: providedPlace ?? model!.providedPlace,
    );
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> updateProfile() async {
    if (model == null) {
      return BaseResponseModel(code: 400, message: 'Vui lòng nhập thông tin');
    }

    final payload = {
      'email': model!.email,
      'full_name': model!.fullName,
      'phone_number': model!.phoneNumber,
      'gender': model!.gender,
      'tax_number': model!.taxNumber,
      'fax_number': model!.faxNumber,
      'website': model!.website,
      'address': {
        'title': model!.address?.title,
        'province': model!.address?.province?.code,
        'district': model!.address?.district?.code,
        'ward': model!.address?.ward?.code,
      },
      'date_of_birth': model!.dateOfBirth.fomatCustom(fomat: 'yyyy-MM-dd'),
      'identify_number': model!.identifyNumber,
      'provided_date': model!.providedDate.fomatCustom(fomat: 'yyyy-MM-dd'),
      'provided_place': model!.providedPlace,
      'bank': bank?.id,
      'account_name': userBankName,
      'account_number': userBankNumber,
    };
    payload.removeWhere((key, value) => value == null || value == '');
    final res = await _repo.updateProfile(payload: payload);

    return res;
  }
}

enum Gender {
  male('MALE'),
  female('FEMALE');

  final String code;

  const Gender(this.code);
}

extension GenderExt on Gender {
  String get getName {
    switch (this) {
      case Gender.male:
        return 'Nam';
      case Gender.female:
        return 'Nữ';
    }
  }
}
