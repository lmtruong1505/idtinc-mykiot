import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/debt/data/models/debt_note_model.dart';
import 'package:pharmago/presentation/features/debt/data/models/payload/dept_note_payload.dart';

import '../../data/models/debt_report_model.dart';

abstract class DebtRepository {
  Future<BaseResponseModel<List<DebtNoteModel>>> list({
    int? page,
    int? limit,
    String? type,
    String? search,
    required int company,
  });

  Future<BaseResponseModel<int>> create({
    required DebtNotePayload data,
  });

  Future<BaseResponseModel<DebtNoteModel>> detail({
    required int debtId,
  });

  Future<BaseResponseModel<DebtReportModel>> report({
    required int company,
    String? status,
    String? type,
  });
}
