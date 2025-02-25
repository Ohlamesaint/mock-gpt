import 'dart:math';

import 'package:chat_gpt_mock/chat/view/widgets/time_stamped_response_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BottomPadding extends MultiChildRenderObjectWidget {
  const BottomPadding({
    super.key,
    super.children,
    required this.viewHeight,
    required this.responseMessage,
  });

  final double viewHeight;
  final String responseMessage;

  @override
  BottomPaddingRenderObject createRenderObject(BuildContext context) {
    return BottomPaddingRenderObject(
      viewHeight: viewHeight,
      responseMessage: responseMessage,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, BottomPaddingRenderObject renderObject) {
    renderObject._viewHeight = viewHeight;
    renderObject.responseMessage = responseMessage;
  }
}

class BottomPaddingElement extends MultiChildRenderObjectElement {
  BottomPaddingElement(BottomPadding super.widget);

  @override
  BottomPadding get widget => super.widget as BottomPadding;

  @override
  BottomPaddingRenderObject get renderObject =>
      super.renderObject as BottomPaddingRenderObject;

  @override
  void forgetChild(Element child) {
    super.forgetChild(child);
    renderObject.markNeedsLayout();
  }

  @override
  void insertRenderObjectChild(RenderBox child, IndexedSlot<Element?> slot) {
    super.insertRenderObjectChild(child, slot);
    renderObject.markNeedsLayout();
  }

  @override
  void deactivateChild(Element child) {
    super.deactivateChild(child);
  }

  @override
  void removeRenderObjectChild(RenderBox child, int slot) {
    super.removeRenderObjectChild(child, slot);
    renderObject.markNeedsLayout();
  }

  @override
  void update(BottomPadding newWidget) {
    super.update(newWidget);
    renderObject._viewHeight = widget.viewHeight;
    renderObject.markNeedsLayout();
  }
}

/// Parent data for use with [BottomPaddingRenderObject].
class BottomPaddingParentData extends ContainerBoxParentData<RenderBox> {
  /// The child's width.
  ///
  /// Ignored if both left and right are non-null.
  double? width;

  /// The child's height.
  ///
  /// Ignored if both top and bottom are non-null.
  double? height;
}

class BottomPaddingRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, BottomPaddingParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, BottomPaddingParentData> {
  BottomPaddingRenderObject({
    List<RenderBox>? children,
    required double viewHeight,
    required String responseMessage,
  }) {
    _viewHeight = viewHeight;
    _responseMessage = responseMessage;
    addAll(children);
  }
  late double _viewHeight;
  late String _responseMessage;

  set viewHeight(double value) {
    if (_viewHeight == value) {
      return;
    }
    _viewHeight = value;
    markNeedsLayout();
  }

  double get viewHeight => _viewHeight;

  String get responseMessage => _responseMessage;

  set responseMessage(String value) {
    if (_responseMessage == value) {
      return;
    }
    _responseMessage = value;
    // markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! BottomPaddingParentData) {
      child.parentData = BottomPaddingParentData();
    }
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    final child = firstChild;
    if (child == null) {
      size = Size(constraints.maxWidth, _viewHeight);
      return;
    }
    final childParentData = child.parentData as BottomPaddingParentData;
    childParentData.offset = Offset.zero;
    child.layout(constraints, parentUsesSize: true);
    final secondChild = lastChild;
    if (secondChild == null) {
      size = Size(constraints.maxWidth, _viewHeight - child.size.height);
      return;
    }
    final secondChildParentData =
        secondChild.parentData as BottomPaddingParentData;
    secondChildParentData.offset = Offset(0, child.size.height);
    secondChild.layout(constraints, parentUsesSize: true);
    size = Size(constraints.maxWidth,
        max(0, _viewHeight - child.size.height - secondChild.size.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);
  }
}
