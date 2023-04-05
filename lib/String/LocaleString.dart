import 'package:get/get.dart';

class LocalString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'Chat': "Chat",
          'Vietnamese': "Vietnamese",
          'English': "English",
          'Setting': "Setting",
          'Enable auto speech': 'Enable auto speech',
          'Delete chat history': 'Delete chat history',
          'Start typing or talking...': 'Start typing or talking...',
          'Language': 'Language'
        },
        'vn_VN': {
          'Chat': "Tin nhắn",
          'Vietnamese': "Tiếng Việt",
          'English': "Tiếng Anh",
          'Setting': "Cài đặt",
          'Enable auto speech': 'Bật từ động đọc',
          'Delete chat history': 'Xoá lịch sử chat',
          'Start typing or talking...': 'Bắt đầu gõ hoặc trò chuyện...',
          'Language': 'Ngôn ngữ',
        }
      };
}
