import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

abstract class ResponseService {
  Stream<String> genResponse(int paragraph, int length);
  List<String> fetchOldMessages();
}

class ResponseServiceImpl implements ResponseService {
  final Random _random = Random(DateTime.now().millisecondsSinceEpoch);

  @override
  Stream<String> genResponse(int paragraph, int length) async* {
    final text = lorem(paragraphs: paragraph, words: length);
    await Future.delayed(Duration(milliseconds: _random.nextInt(500)));
    for (var char in text.characters) {
      await Future.delayed(Duration(milliseconds: _random.nextInt(10)));
      yield char;
    }
    return;
  }

  @override
  List<String> fetchOldMessages() {
    return List.generate(6, (index) => lorem(paragraphs: 1, words: 10));
  }
}
