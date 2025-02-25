import 'package:chat_gpt_mock/chat/chat_page.dart';
import 'package:chat_gpt_mock/chat/service/response_service.dart';
import 'package:chat_gpt_mock/chat/view/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. Localization
// 2. Themes
// 3. Navigation (go-route)
// 4. Sliver

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ChatViewModelImpl(ResponseServiceImpl())),
      ],
      child: MaterialApp(
        title: 'ChatGPT Mock',
        theme: ThemeData.dark().copyWith(
          primaryColorDark: Colors.black,
          primaryColorLight: Colors.white,
          cardColor: const Color(0xFF212121),
        ),
        home: Container(
          color: const Color(0xFF212121),
          child: const SafeArea(
            top: false,
            child: ChatPage(),
          ),
        ),
      ),
    );
  }
}
