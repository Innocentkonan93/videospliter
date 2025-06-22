import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BotService {
  static const String token = "7641964638:AAH5iJwuYmE2lnQHbqtXe-Yx6d6bkLHRC2E";
  static const String baseUrl = "https://api.telegram.org/bot$token";

  static const chatId = '5689989310';

  Future<bool> sendFeedback(String feedback, {List<String>? imagePaths}) async {
    // Send text feedback
    final textResponse = await http.post(
      Uri.parse("$baseUrl/sendMessage"),
      body: {"text": feedback, "chat_id": chatId},
    );

    if (textResponse.statusCode != 200) {
      if (kDebugMode) {
        print(textResponse.body);
        print("Failed to send feedback text");
      }
      return false;
    }

    log(textResponse.statusCode.toString());
    // Send images if provided
    if (imagePaths != null) {
      for (final imagePath in imagePaths) {
        final imageFile = await http.MultipartFile.fromPath('photo', imagePath);
        final request = http.MultipartRequest(
          'POST',
          Uri.parse("$baseUrl/sendPhoto"),
        );
        request.fields['chat_id'] = chatId;
        request.files.add(imageFile);

        final imageResponse = await request.send();
        if (imageResponse.statusCode != 200) {
          print("Failed to send image: $imagePath");
        }
      }
    }

    log("Feedback sent successfully");
    return true;
  }
}
