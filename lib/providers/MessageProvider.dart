import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/models/Message.dart';

class MessageNotifier extends StateNotifier<List<Message>>{
  MessageNotifier() : super([]);
  void add(Message message){
    state = [...state, message];
  }
  void addList(Message message){
    state = [...state, message];
  }

}
final messagesProvider = StateNotifierProvider<MessageNotifier, List<Message>>((ref) => MessageNotifier(),
);