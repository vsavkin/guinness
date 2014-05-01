library html_utils;

import 'dart:html';

String toHtml(node, {Function preprocess, bool outer: false}) {
  if (preprocess != null) {
    node = preprocess(node);
  }

  if (node is Comment) {
    return '<!--${node.text}-->';

  } else if (node is Text) {
    return node.text;

  } else if (node is DocumentFragment) {
    return node.childNodes.map((n) => toHtml(n, outer: true, preprocess: preprocess)).join("");

  } else if (node is List) {
    return node.map((n) => toHtml(n, preprocess: preprocess)).join("");

  } else if (node is Element) {
    var htmlString = outer ? node.outerHtml : node.innerHtml;
    return htmlString.replaceAll(' class=""', '').trim();

  } else {
    throw "JQuery._toHtml not implemented for node type [${node.nodeType}]";
  }
}

String elementText(n, [bool notShadow = false]) {
  if (n is Iterable) {
    return n.map((nn) => elementText(nn)).join("");
  }

  if (n is Comment) return '';

  if (!notShadow && n is Element && n.shadowRoot != null) {
    var cShadows = n.shadowRoot.nodes.map((n) => n.clone(true)).toList();
    for (var i = 0, ii = cShadows.length; i < ii; i++) {
      var n = cShadows[i];
      if (n is Element) {
        var updateElement = (e) {
          var text = new Text('SHADOW-CONTENT');
          if (e.parent == null) {
            cShadows[i] = text;
          } else {
            e.parent.insertBefore(text, e);
          }
          e.nodes = [];
        };
        if (n is ContentElement) { updateElement(n); }
        n.querySelectorAll('content').forEach(updateElement);
      }
    };
    var shadowText = elementText(cShadows, true);
    var domText = elementText(n, true);

    return shadowText.replaceFirst("SHADOW-CONTENT", domText);
  }

  if (n.nodes == null || n.nodes.length == 0) return n.text;

  return n.nodes.map((cn) => elementText(cn)).join("");
}