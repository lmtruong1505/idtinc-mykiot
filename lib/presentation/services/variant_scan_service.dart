import 'package:injectable/injectable.dart';
import 'package:pharmago/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

import '../../env/env_config.dart';

@injectable
class VariantScanService {
  late PharmagoClient client;

  VariantScanService() {
    client = PharmagoClient(
      ClientChannel(
        EnvironmentConfig.BASE_URL_GRPC,
        port: 9090,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      ),
    );
  }
}
