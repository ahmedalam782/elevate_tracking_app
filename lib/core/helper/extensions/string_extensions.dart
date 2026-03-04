import 'package:url_launcher/url_launcher.dart';

extension PhoneLauncher on String {
  Future<void> callPhone() async {
    final uri = Uri.parse('tel:$this');

    final launched = await launchUrl(uri);

    if (!launched) {
      throw Exception('Could not launch phone dialer');
    }
  }

  Future<void> openWhatsApp({String? message}) async {
    final encodedMessage = Uri.encodeComponent(message ?? '');
    final uri = Uri.parse(
      'https://wa.me/$this${message != null ? '?text=$encodedMessage' : ''}',
    );

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      throw Exception('Could not launch WhatsApp');
    }
  }
}
