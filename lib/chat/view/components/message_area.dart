import 'package:chat_gpt_mock/chat/view/view_model/chat_view_model.dart';
import 'package:chat_gpt_mock/chat/view/widgets/message.dart';
import 'package:chat_gpt_mock/chat/view/widgets/bottom_padding.dart';
import 'package:chat_gpt_mock/chat/view/widgets/time_stamped_response_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageArea extends StatefulWidget {
  const MessageArea({super.key});

  @override
  State<MessageArea> createState() => _MessageAreaState();
}

class _MessageAreaState extends State<MessageArea> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final centerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final messages = context.watch<ChatViewModelImpl>().messages;
    final oldMessages = context.watch<ChatViewModelImpl>().oldMessages;
    return Expanded(
      child: LayoutBuilder(builder: (context, constraint) {
        return ColoredBox(
          color: Theme.of(context).primaryColorDark,
          child: messages.isEmpty
              ? Container()
              : RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ChatViewModelImpl>().fetchOldMessages();
                  },
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    // This method is available to conveniently determine if an scroll
                    // view is reversed by its AxisDirection.
                    reverse: axisDirectionIsReversed(AxisDirection.down),
                    // This method is available to conveniently convert an AxisDirection
                    // into its Axis.
                    scrollDirection: axisDirectionToAxis(AxisDirection.down),
                    // Places the leading edge of the center sliver in the middle of the
                    // viewport. Changing this value between 0.0 (the default) and 1.0
                    // changes the position of the inflection point between GrowthDirections
                    // in the viewport when the slivers are laid out.
                    center: centerKey,
                    anchor: 0,
                    controller: context.watch<ChatViewModelImpl>().controller,
                    slivers: [
                      SliverList.builder(
                        itemCount: oldMessages.length,
                        itemBuilder: (context, index) {
                          return Message(
                            index: index,
                            isOld: true,
                          );
                        },
                      ),
                      SliverList.builder(
                        itemCount: messages.length - 2,
                        itemBuilder: (context, index) {
                          return Message(
                            index: index + 3,
                            isOld: false,
                          );
                        },
                      ),
                      SliverToBoxAdapter(
                        key: centerKey,
                        child: const Message(
                          index: 2,
                          isOld: false,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Message(
                          index: 1,
                          isOld: false,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
