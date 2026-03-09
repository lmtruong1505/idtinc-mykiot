import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/customer/data/mapper/customer_entity_mapper.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/customer_repository.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

@injectable
class CustomerUseCase {
  CustomerUseCase(this._repository, this._mapper);
  final CustomerRepository _repository;
  final CustomerEntityMapper _mapper;

  Future<BaseResponseModel<List<CustomerEntity>>> getList(
    int company,
    String search,
    int page,
  ) async {
    final res = await _repository.getList(company, search, page);
    return BaseResponseModel(
      code: res.code,
      message: res.message,
      data: _mapper.mapToListEntity(res.data),
      extra: res.extra,
    );
  }

  Future<CustomerEntity> getDetail(int id) async {
    final res = await _repository.getDetail(id);
    return _mapper.mapToEntity(res.data);
  }

  Future<BaseResponseModel<CustomerEntity>> fastCreate(
      {required String phone, required String name}) async {
    final company = AppSharedPreference.instance.getValue(PrefKeys.company);
    final payload = {
      'code': null,
      'phone': phone,
      'name': name,
      'company': company,
    };
    final res = await _repository.create(payload);
    return BaseResponseModel(
      code: res.code,
      message: res.message,
      data: _mapper.mapToEntity(res.data),
    );
  }

  Future<BaseResponseModel> create(CustomerEntity customer) async {
    final company = AppSharedPreference.instance.getValue(PrefKeys.company);
    final payload = {
      'code': customer.code?.trim(),
      'name': customer.name?.trim(),
      'phone': customer.phone?.trim(),
      'address': {
        'lat': customer.address?.lat,
        'lng': customer.address?.lat,
        'province': customer.address?.province?.code,
        'district': customer.address?.district?.code,
        'ward': customer.address?.ward?.code,
        'title': customer.address?.detail,
      },
      'birthday': customer.birthday == null
          ? null
          : DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'")
              .format(customer.birthday!),
      'gender': customer.gender,
      'group': customer.group,
      'company': company,
      'email': customer.email,
      'contact_name': customer.contactName,
      'contact_title': customer.contactTitle,
      'contact_phone': customer.contactPhone,
      'contact_email': customer.contactEmail,
      'contact_address': {
        'lat': customer.contactAddress?.lat,
        'lng': customer.contactAddress?.lat,
        'province': customer.contactAddress?.province?.code,
        'district': customer.contactAddress?.district?.code,
        'ward': customer.contactAddress?.ward?.code,
        'title': customer.contactAddress?.detail,
      },
      'account_number': customer.accountNumber,
      'bank_name': customer.bankName,
      'bank_branch': customer.bankBranch,
    };
    payload.removeWhere((key, value) => value == null);
    if (customer.contactAddress?.province == null) {
      payload.remove('contact_address');
    }
    return _repository.create(payload);
  }

  Future<BaseResponseModel> update(CustomerEntity customer) async {
    final company = AppSharedPreference.instance.getValue(PrefKeys.company);
    final payload = {
      'code': customer.code?.trim(),
      'name': customer.name?.trim(),
      'phone': customer.phone?.trim(),
      'address': {
        'lat': customer.address?.lat,
        'lng': customer.address?.lat,
        'province': customer.address?.province?.code,
        'district': customer.address?.district?.code,
        'ward': customer.address?.ward?.code,
        'title': customer.address?.title,
      },
      'birthday': customer.birthday == null
          ? null
          : DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'")
              .format(customer.birthday!),
      'gender': customer.gender,
      'group': customer.group,
      'company': company,
      'email': customer.email,
      'contact_name': customer.contactName,
      'contact_title': customer.contactTitle,
      'contact_phone': customer.contactPhone,
      'contact_email': customer.contactEmail,
      'contact_address': {
        'lat': customer.contactAddress?.lat,
        'lng': customer.contactAddress?.lat,
        'province': customer.contactAddress?.province?.code,
        'district': customer.contactAddress?.district?.code,
        'ward': customer.contactAddress?.ward?.code,
        'title': customer.contactAddress?.detail,
      },
      'account_number': customer.accountNumber,
      'bank_name': customer.bankName,
      'bank_branch': customer.bankBranch,
    };

    return _repository.update(
      customer.id!,
      payload,
    );
  }

  Future<BaseResponseModel> delete(int id) async {
    return _repository.delete(id);
  }
}
