ifeq ($(OS),Windows_NT)
    BUILD_CMD=.\build_and_run_app.bat
    METRICS_CMD=.\tools\dart_code_metrics.bat
    COMMIT_CHECK_CMD=.\tools\check_commit_message.bat
else
    BUILD_CMD=./build_and_run_app.sh
    METRICS_CMD=./tools/dart_code_metrics.sh
    COMMIT_CHECK_CMD=./tools/check_commit_message.sh
endif


clean:
	flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs

get:
	flutter clean && flutter pub get

run:
	dart run build_runner build --delete-conflicting-outputs

run_watch:
	flutter packages pub run build_runner watch

run_watch_delete_conflic:
	fvm flutter packages pub run build_runner watch --delete-conflicting-outputs

run_build_delete_conflic:
	fvm flutter packages pub run build_runner build --delete-conflicting-outputs

build_apk_ip:
	fvm flutter build apk --dart-define=DART_DEFINES_BASE_URL_HTTP="https://159.65.129.155:8000/api"

build_apk_dev:
	flutter build apk --dart-define=DART_DEFINES_BASE_URL_HTTP="https://core.kafa.pro"

build_apk_pro:
	fvm flutter build apk --dart-define=DART_DEFINES_BASE_URL_HTTP="https://mykiot-pharmago.too.onl/api" --dart-define=DART_DEFINES_URL_KAFA="https://api.kafa.pro"

build_appbundle:
	fvm flutter build appbundle --release --dart-define=DART_DEFINES_BASE_URL_HTTP="https://mykiot-pharmago.too.onl" --dart-define=DART_DEFINES_URL_KAFA="https://api.kafa.pro"

build_runner:
	flutter packages pub run build_runner watch --delete-conflicting-outputs

proto:
	protoc --dart_out=grpc:lib/pb -I protos protos/*.proto

# build_apk:
# 	fvm flutter build apk "--dart-define=MODE=dev" --dart-define=DART_DEFINES_BASE_URL_HTTP="https://159.65.129.155:8000/api" --dart-define=DART_DEFINES_URL_KAFA="https://core.kafa.pro"

build_ios_pro:
	flutter build ipa "--dart-define=MODE=dev" --dart-define=DART_DEFINES_BASE_URL_HTTP="https://159.65.129.155:8000/api" --dart-define=DART_DEFINES_URL_KAFA="https://core.kafa.pro"

aab:
	fvm flutter build appbundle "--dart-define=MODE=pro" --dart-define=DART_DEFINES_BASE_URL_HTTP="https://mykiot-pharmago.too.onl/api" --dart-define=DART_DEFINES_URL_KAFA="https://api.kafa.pro"

ipa:
	flutter build ipa  "--dart-define=MODE=pro" --dart-define=DART_DEFINES_BASE_URL_HTTP="https://mykiot-pharmago.too.onl/api" --dart-define=DART_DEFINES_URL_KAFA="https://api.kafa.pro"

apk:
	flutter build apk "--dart-define=MODE=pro" --dart-define=DART_DEFINES_BASE_URL_HTTP="https://mykiot-pharmago.too.onl/api" --dart-define=DART_DEFINES_URL_KAFA="https://api.kafa.pro"
	
rm:
	flutter clean && flutter pub get && rm -rf ios/Pods ios/Podfile.lock && cd ios && pod install

tree:
	flutter pub deps > dependencies.txt

open:
	open ios/Runner.xcworkspace

run_terminal:
	fvm flutter run lib/main.dart -d $(device) \
		--dart-define=DART_DEFINES_APP_NAME=Pharmago \
		--dart-define=DART_DEFINES_APP_SUFFIX= \
		--dart-define=DART_DEFINES_BASE_URL_HTTP=https://mykiot-pharmago.too.onl/api \
		--dart-define=DART_DEFINES_BASE_URL=https://api.kafa.pro
