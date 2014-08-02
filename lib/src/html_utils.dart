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
  }

  throw "toHtml not implemented for node type [${node.nodeType}]";
}

String elementText(n) {
  hasShadowRoot(n) => n is Element && n.shadowRoot != null;
  hasNodes(n) => n.nodes != null && n.nodes.isNotEmpty;

  if (n is Iterable)        return n.map((nn) => elementText(nn)).join("");
  if (n is Comment)         return '';
  if (n is ContentElement)  return elementText(n.getDistributedNodes());
  if (hasShadowRoot(n))     return elementText(n.shadowRoot.nodes);
  if (hasNodes(n))          return elementText(n.nodes);;

  return n.text;
}