import 'package:chat_gpt_mock/chat/view/view_model/chat_view_model.dart';
import 'package:chat_gpt_mock/chat/view/widgets/time_stamped_response_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.index,
    required this.isOld,
  });

  final int index;
  final bool isOld;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
          vertical: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: (index + (isOld ? 1 : 0)) % 2 == 0
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((index + (isOld ? 1 : 0)) % 2 == 1)
            CircleAvatar(
              backgroundColor: Theme.of(context).cardColor,
              maxRadius: MediaQuery.of(context).size.width * 0.05,
              child: const FlutterLogo(),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025),
            child: Container(
              decoration: BoxDecoration(
                color: (index + (isOld ? 1 : 0)) % 2 == 0
                    ? Theme.of(context).cardColor
                    : Theme.of(context).primaryColorDark,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: TimeStampedMessage(
                    text: isOld
                        ? context.watch<ChatViewModelImpl>().oldMessages[index]
                        : context.watch<ChatViewModelImpl>().messages[index],
                    isUser: (index + (isOld ? 1 : 0)) % 2 == 0,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      // backgroundColor: Colors.blue
                    ),
                  ),
                ),
              ),
            ),
          ),
          if ((index + (isOld ? 1 : 0)) % 2 == 0)
            CircleAvatar(
              backgroundColor: Theme.of(context).cardColor,
              maxRadius: MediaQuery.of(context).size.width * 0.05,
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
