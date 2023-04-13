import 'package:flutter/material.dart';

/// Recognizes URL's in [text] and represents them as tappable URL links
/// and applies [onTap] callback if [launchUrlOnTap] is ture
class TextUrlRecognizable extends StatelessWidget {
  const TextUrlRecognizable(
    this.text, {
    Key? key,
    this.style,
    this.urlColor = Colors.blueAccent,
    this.launchUrlOnTap = true,
    this.onTap,
  }) : super(key: key);

  static final RegExp urlRegExp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

  ///Initial text to extract possible URL
  final String? text;

  ///Style of extracted URL link
  final TextStyle? style;

  ///TextColor of extracted URL link
  final Color? urlColor;

  final bool launchUrlOnTap;

  /// Callback to be called if [launchUrlOnTap] == `true`
  final dynamic Function(String)? onTap;

  @override
  Widget build(BuildContext context) => Text.rich(TextSpan(children: _generateInlineSpans(text!), style: style));

  ///Splits original text into spans including "URL-styled" span
  List<InlineSpan> _generateInlineSpans(String text) {
    final List<InlineSpan> list = <InlineSpan>[];
    final RegExpMatch? match = urlRegExp.firstMatch(text);
    if (match == null) {
      list.add(TextSpan(text: text));
      return list;
    }
    if (match.start > 0) {
      list.add(TextSpan(text: text.substring(0, match.start)));
    }
    final String linkText = match.group(0)!;
    list.add(_buildUrlSpan(linkText, linkText));
    list.addAll(_generateInlineSpans(text.substring(match.start + linkText.length)));
    return list;
  }

  ///Builds "Url-styled" span of extracted URL
  WidgetSpan _buildUrlSpan(String text, String linkToOpen) {
    TextStyle urlStyle = style ?? const TextStyle();
    urlStyle = urlStyle.copyWith(color: urlColor, decoration: TextDecoration.underline);
    return WidgetSpan(
        child: InkWell(
      onTap: (launchUrlOnTap && onTap != null) ? onTap!(linkToOpen) : () {},
      child: Text(text, style: urlStyle),
    ));
  }
}
