


import 'package:flutter/material.dart';
import 'package:zefyrka/zefyrka.dart';

List<TextSpan> _buildTextSpans(NotusDocument doc) {
  var response = <TextSpan>[];

  for (var node in doc.root.children) {
    response.addAll(_getSpans(node));
  }

  return response;
}

List<TextSpan> _getSpans(Node node) {
  var response = <TextSpan>[];
  if (node is TextNode) {
    if (node.style.contains(NotusAttribute.bold)) {
      response.add(TextSpan(text: node.toPlainText(), style: TextStyle(fontWeight: FontWeight.bold)));
    } else {
      response.add(TextSpan(text: node.toPlainText()));
    }
  } else {
    if (node is LineNode) {
      response.add(TextSpan(text: '\n\n'));
      for (var n in node.children) {
        response.addAll(_getSpans(n));
      }
    }
  }

  return response;
}
