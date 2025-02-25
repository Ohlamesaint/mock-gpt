import 'package:chat_gpt_mock/chat/view/view_model/chat_view_model.dart';
import 'package:chat_gpt_mock/chat/view/widgets/message.dart';
import 'package:chat_gpt_mock/chat/view/widgets/bottom_padding.dart';
import 'package:chat_gpt_mock/chat/view/widgets/time_stamped_response_box.dart';
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
    print("[VVV] rebuild!");
    return Expanded(
      child: LayoutBuilder(builder: (context, constraint) {
        return ColoredBox(
            color: Theme.of(context).primaryColorDark,
            child: messages.isEmpty
                ? Container()
                : RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<ChatViewModelImpl>()
                          .fetchOldMessages();
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
                          key: centerKey,
                          itemCount: messages.length + 1,
                          itemBuilder: (context, index) {
                            return index == messages.length
                                ? BottomPadding(
                                    viewHeight: constraint.maxHeight +
                                        MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                    responseMessage:
                                        "messages[messages.length - 1]",
                                    children: [
                                      Message(
                                        index: messages.length - 2,
                                        isOld: false,
                                      ),
                                      Message(
                                        index: messages.length - 1,
                                        isOld: false,
                                      ),
                                    ],
                                  )
                                : Message(
                                    index: index,
                                    isOld: false,
                                  );
                          },
                        ),
                      ],
                    ),
                  )
            // CustomScrollView(
            //   controller: context.watch<ChatViewModelImpl>().controller,
            //   physics: const ClampingScrollPhysics(),
            //   slivers: [
            //     if (messages.isNotEmpty)
            //       RefreshIndicator(
            //         onRefresh: () async {
            //           await Future<void>.delayed(const Duration(seconds: 1));
            //           print("[VVV] fetch finished!");
            //           // context.read<ChatViewModelImpl>().fetchMessages();
            //         },
            //         child: SliverList.builder(
            //           itemCount: messages.length + 1,
            //           itemBuilder: (context, index) {
            //             print(
            //                 "[VVV] height: ${MediaQuery.of(context).size.height}}");
            //             return index == messages.length
            //                 ? BottomPadding(
            //                     viewHeight: constraint.maxHeight +
            //                         MediaQuery.of(context).viewInsets.bottom,
            //                     responseMessage: "messages[messages.length - 1]",
            //                     children: [
            //                       Message(
            //                         index: messages.length - 2,
            //                       ),
            //                       Message(
            //                         index: messages.length - 1,
            //                       ),
            //                     ],
            //                   )
            //                 : Message(
            //                     index: index,
            //                   );
            //           },
            //         ),
            //       ),
            //   ],
            // ),
            );
      }),
    );
  }
}
