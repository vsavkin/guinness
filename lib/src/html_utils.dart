library html_utils;

import 'dart:html';

String toHtml(node, [bool outer = false]) {
  if (node is Comment) {
    return '<!--${node.text}-->';

  } else if (node is Text) {
    return node.text;

  } else if (node is DocumentFragment) {
    return node.childNodes.map((n) => toHtml(n, true)).join("");

  } else if (node is List) {
    return node.map(toHtml).join("");

  } else if (node is Element) {
    var htmlString = outer ? node.outerHtml : node.innerHtml;
    return htmlString.replaceAll(' class=""', '').trim();

  } else {
    throw "JQuery._toHtml not implemented for node type [${node.nodeType}]";
  }
}

String elementText(n, [bool notShadow = false]) {
  if (n is Comment) return '';
  if (n is List) return n.map(elementText).join("");

  if (!notShadow && n is Element && n.shadowRoot != null) {
    var shadowText = n.shadowRoot.text;
    var domText = elementText(n, true);
    return shadowText.replaceFirst("SHADOW-CONTENT", domText);
  }

  if (n.nodes == null || n.nodes.length == 0) return n.text;
  return elementText(n.nodes);
}