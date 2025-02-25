import 'package:chat_gpt_mock/chat/core/response_status.dart';
import 'package:chat_gpt_mock/chat/service/response_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class ChatViewModel {
  void onSendMessage(String message);
  Future<void> fetchOldMessages();
  void onCleanMessage();
}

class ChatViewModelImpl with ChangeNotifier implements ChatViewModel {
  final ResponseService _responseService;
  ResponseStatus _status = ResponseStatus.done;
  final ScrollController _controller = ScrollController();

  List<String> _messages = [];
  List<String> _oldMessages = [];
  Stream<String>? _responseStream;

  List<String> get messages => _messages;
  List<String> get oldMessages => _oldMessages;
  Stream<String>? get responseStream => _responseStream;
  ScrollController get controller => _controller;

  set responseStream(Stream<String>? value) {
    _responseStream = value;
    notifyListeners();
  }

  set messages(List<String> value) {
    _messages = [...value];
  }

  ChatViewModelImpl(this._responseService);

  @override
  Future<void> onSendMessage(String message) async {
    messages = ['...', message, ...messages];

    notifyListeners();

    if (message.toLowerCase().contains("long")) {
      responseStream = _responseService.genResponse(10, 100);
    } else {
      responseStream = _responseService.genResponse(1, 10);
    }
    // await scrollToBottom();
    await SchedulerBinding.instance.endOfFrame;
    _controller.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    await SchedulerBinding.instance.endOfFrame;

    responseStream!.listen(
      _onMessageGen,
      onDone: () {
        _status = ResponseStatus.done;
      },
    );
  }

  @override
  Future<void> fetchOldMessages() async {
    await Future.delayed(const Duration(seconds: 1));
    _oldMessages = [..._oldMessages, ..._responseService.fetchOldMessages()];
    notifyListeners();
  }

  @override
  void onCleanMessage() {
    messages.clear();
    oldMessages.clear();
    notifyListeners();
  }

  Future<void> scrollToBottom() async {
    await SchedulerBinding.instance.endOfFrame;
    while (
        _controller.position.pixels != _controller.position.maxScrollExtent) {
      await _controller.animateTo(_controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 50), curve: Curves.linear);
    }
  }

  void _onMessageGen(String message) {
    final newMessage =
        _status == ResponseStatus.done ? message : messages.first + message;
    _status = ResponseStatus.generating;
    messages = [
      newMessage,
      ...messages.sublist(1, messages.length),
    ];
    notifyListeners();
  }
}
