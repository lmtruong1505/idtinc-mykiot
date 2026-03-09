import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  LaunchUrl._();

  static url(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  static googleMap(String address) async {
    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';

    await launchUrl(Uri.parse(googleUrl));
  }

  static mail(String emailto, {String? content}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailto,
      queryParameters: content == null
          ? null
          : <String, String>{
              'body': Uri.encodeComponent(content),
            },
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $emailto');
    }
  }

  static phone(String phone) async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phone.startsWith('+84')
          ? phone
          : '+84${phone.substring(1, phone.length)}',
    );
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  static openZalo(String zaloId) async {
    final url = 'https://zalo.me/$zaloId';
    await launchUrl(Uri.parse(url));
  }

  static sms(String phone, {String? content}) async {
    final Uri uri = Uri(
      scheme: 'sms',
      path: '+84339604406',
      queryParameters: content == null
          ? null
          : <String, String>{
              'body': Uri.encodeComponent(content),
            },
    );
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  static Future openMessenger({
    required String idMessager,
  }) async {
    await launchUrl(
      Uri.parse('https://m.me/$idMessager'),
      mode: LaunchMode.externalApplication,
    );
  }

  static Future openFaceBook({
    required String idFacebook,
  }) async {
    await launchUrl(
      Uri.parse('https://www.facebook.com/$idFacebook'),
      mode: LaunchMode.externalApplication,
    );
  }
}
