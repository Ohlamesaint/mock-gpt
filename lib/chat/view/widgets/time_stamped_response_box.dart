import 'package:chat_gpt_mock/chat/view/widgets/bottom_padding.dart';
import 'package:chat_gpt_mock/utils/date_conversion_utils.dart';
import 'package:flutter/material.dart';

class TimeStampedMessage extends LeafRenderObjectWidget {
  const TimeStampedMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.textStyle,
  });

  final String text;
  final bool isUser;
  final TextStyle textStyle;

  // Step3.1: Implement the updateRenderObject method
  @override
  void updateRenderObject(
      BuildContext context, TimeStampedMessageRenderObject renderObject) {
    renderObject.text = text;
    renderObject.textStyle = textStyle;
    renderObject.textDirection = isUser ? TextDirection.rtl : TextDirection.ltr;
    renderObject.textAlign = isUser ? TextAlign.right : TextAlign.left;
  }

// Step3.2: Implement the createRenderObject method
  @override
  TimeStampedMessageRenderObject createRenderObject(BuildContext context) {
    return TimeStampedMessageRenderObject(
      text: text,
      sendAt: DateConversionUtils.convertDateTimeToString(DateTime.now()),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textDirection: isUser ? TextDirection.rtl : TextDirection.ltr,
      textAlign: isUser ? TextAlign.left : TextAlign.left,
    );
  }
}

class TimeStampedMessageRenderObject extends RenderBox {
  // Step1: Add the required fields
  TimeStampedMessageRenderObject({
    required String text,
    required String sendAt,
    required TextStyle textStyle,
    required TextDirection textDirection,
    required TextAlign textAlign,
  }) {
    _text = text;
    _sendAt = sendAt;
    _textStyle = textStyle;
    _textDirection = textDirection;
    _textAlign = textAlign;

    _textPainter = TextPainter(
      text: textTextSpan,
      textDirection: _textDirection,
      textAlign: _textAlign,
    );

    _sendAtPainter = TextPainter(
      text: sendAtTextSpan,
      textDirection: _textDirection,
      textAlign: _textAlign,
    );
    markNeedsLayout();
  }

  late String _text;
  late String _sendAt;
  late TextStyle _textStyle;
  late TextDirection _textDirection;
  late TextAlign _textAlign;

  late TextPainter _textPainter;
  late TextPainter _sendAtPainter;

  // Step2: implement getter/setter for the fields
  String get text => _text;
  set text(String value) {
    if (_text == value) return; // guard statement
    _text = value;
    _textPainter.text = textTextSpan;
    markNeedsLayout();
  }

  TextSpan get textTextSpan => TextSpan(
        text: _text,
        style: _textStyle,
      );
  TextSpan get sendAtTextSpan => TextSpan(
      text: _sendAt,
      style: _textStyle.copyWith(
        color: Colors.grey,
        fontSize: 12,
      ));

  String get sendAt => _sendAt;
  set sendAt(String value) {
    if (_sendAt == value) return; // guard statement
    _sendAt = value;
    _sendAtPainter.text = sendAtTextSpan;
  }

  TextStyle get textStyle => _textStyle;
  set textStyle(TextStyle value) {
    if (_textStyle == value) return; // guard statement
    _textStyle = value;
    _textPainter.text = textTextSpan;
    _sendAtPainter.text = sendAtTextSpan;
  }

  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return; // guard statement
    _textDirection = value;
    _textPainter.textDirection = value;
    _sendAtPainter.textDirection = value;
    markNeedsLayout();
  }

  TextAlign get textAlign => _textAlign;
  set textAlign(TextAlign value) {
    if (_textAlign == value) return; // guard statement
    _textAlign = value;
    _textPainter.textAlign = value;
    _sendAtPainter.textAlign = value;
  }

  double _lineMaxWidth = 0;
  int _lines = 0;
  double _lineHeight = 0;
  double _lastLineWidth = 0;

  double _sendAtWidth = 0;
  double _sendAtHeight = 0;
  Size _computedSize = Size.zero;
  // Step4: Implement the performLayout method
  // determine the dimension of the render object
  // and store the result in the size field
  @override
  void performLayout() {
    _textPainter.layout(maxWidth: constraints.maxWidth);
    _sendAtPainter.layout();

    final metrics = _textPainter.computeLineMetrics();
    _lines = metrics.length;
    _lineMaxWidth = metrics.fold<double>(
      0,
      (previousValue, element) =>
          element.width > previousValue ? element.width : previousValue,
    );
    _lineHeight = metrics.first.height;
    _lastLineWidth = metrics.last.width;

    final sendAtMetrics = _sendAtPainter.computeLineMetrics();
    _sendAtWidth = sendAtMetrics[0].width;
    _sendAtHeight = sendAtMetrics[0].height;

    _computedSize = Size(
      _lineMaxWidth > _sendAtWidth ? _lineMaxWidth : _sendAtWidth,
      _lineHeight * _lines + _sendAtHeight,
    );

    size = constraints.constrain(_computedSize);
    parentData = BottomPaddingParentData()
      ..height = size.height
      ..width = size.width;
  }

  @override
  bool get debugCanParentUseSize => true;

  // Step5: Implement the paint method
  // render the content of the render object
  @override
  void paint(PaintingContext context, Offset offset) {
    _textPainter.paint(
        context.canvas,
        Offset(
          _textAlign == TextAlign.right
              ? offset.dx + size.width - _lineMaxWidth
              : offset.dx,
          offset.dy,
        ));
    _sendAtPainter.paint(
      context.canvas,
      Offset(
        _textAlign == TextAlign.right
            ? offset.dx
            : offset.dx + size.width - _sendAtWidth,
        offset.dy + size.height - _sendAtHeight,
      ),
    );
  }
}
