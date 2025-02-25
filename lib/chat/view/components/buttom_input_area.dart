import 'package:chat_gpt_mock/chat/view/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomInputArea extends StatelessWidget {
  const BottomInputArea({
    super.key,
    required this.focusNode,
    required this.controller,
  });

  final FocusNode focusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).primaryColorDark,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30, right: 20, bottom: 10),
                constraints:
                    const BoxConstraints(minHeight: 50, maxHeight: 150),
                child: TapRegion(
                  onTapOutside: (_) => focusNode.unfocus(),
                  child: TextField(
                    focusNode: focusNode,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Type a message',
                    ),
                    controller: controller,
                    cursorColor: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FlutterLogo(),
                  ListenableBuilder(
                      listenable: context.watch<ChatViewModelImpl>(),
                      builder: (context, _) {
                        return IconButton(
                          onPressed: context
                                  .watch<ChatViewModelImpl>()
                                  .messages
                                  .isEmpty
                              ? null
                              : () => context
                                  .read<ChatViewModelImpl>()
                                  .onCleanMessage(),
                          disabledColor: Colors.grey,
                          color: Colors.white,
                          icon: const Icon(
                            Icons.cleaning_services,
                          ),
                        );
                      }),
                  const Spacer(),
                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) => IconButton(
                      onPressed: controller.value.text.isEmpty
                          ? null
                          : () {
                              context
                                  .read<ChatViewModelImpl>()
                                  .onSendMessage(controller.text);
                              controller.clear();
                            },
                      disabledColor: Colors.grey,
                      color: Colors.white,
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
