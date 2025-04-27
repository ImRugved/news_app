import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<bool> openUrl(
    String urlString, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      if (urlString.isEmpty) {
        log('URL is empty');
        return false;
      }

      // Ensure URL starts with http:// or https://
      if (!urlString.startsWith('http://') &&
          !urlString.startsWith('https://')) {
        urlString = 'https://$urlString';
      }

      log('Trying to open URL: $urlString');

      final url = Uri.parse(urlString);

      // First check if URL can be launched
      final canLaunch = await canLaunchUrl(url);
      log('Can launch URL: $canLaunch');

      if (!canLaunch) {
        log('Cannot launch URL: $url');
        return false;
      }

      // Try to launch URL
      final result = await launchUrl(url, mode: mode);
      log('URL launch result: $result');

      return result;
    } catch (e) {
      log('Error launching URL: $e');
      return false;
    }
  }

  static void showUrlErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
