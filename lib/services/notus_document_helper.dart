///
/// Incorporates simple helper methods for dealing with [NotusDocument]s
///
library notus_document_helper;


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';
import 'package:zefyrka/zefyrka.dart';




NotusDocument buildDocument(String content) {
  var list = const JsonDecoder().convert(content);
  var list2 = [];
  for (var item in list) {
    var newItem = item;
    newItem['insert'] = item['insert'] + '\n';
    list2.add(newItem);
  }

  NotusDocument doc = NotusDocument.fromJson(list2);
  return doc;
}


List<TextSpan> buildTextSpans(NotusDocument doc) {

  var response = <TextSpan>[];

  for (var node in doc.root.children) {
    response.addAll(getSpans(node));
  }

  return response;
}

List<TextSpan> getSpans(Node node, {TextStyle style = coreStyle}) {
  var response = <TextSpan>[];
  if (node is TextNode) {
    if (node.style.contains(NotusAttribute.bold)) {
      response.add(TextSpan(text: node.toPlainText(), style: coreStyle.copyWith(fontWeight: FontWeight.bold)));
    } else {
      response.add(TextSpan(text: node.toPlainText(), style: coreStyle));
    }
  } else {
    if (node is LineNode) {
      response.add(const TextSpan(text: '\n\n', style: coreStyle));
      for (var n in node.children) {
        response.addAll(getSpans(n));
      }
    }
  }

  return response;
}

