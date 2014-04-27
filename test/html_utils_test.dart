library html_utils_test;

import 'package:guinness/src/html_utils.dart' as utils;
import 'package:unittest/unittest.dart';
import 'dart:html';

main() {
  group("[toHtml]", () {
    test('handles comments', () {
      final c = new Comment("some data");
      expect(utils.toHtml(c), equals('<!--some data-->'));
    });

    test('handles text', () {
      final t = new Text("some data");
      expect(utils.toHtml(t), equals("some data"));
    });

    test('handles list', () {
      final t1 = new Text("t1");
      final t2 = new Text("t2");
      expect(utils.toHtml([t1, t2]), equals("t1t2"));
    });

    test('handles document fragment', () {
      final d = new DocumentFragment.html("<div>one</div><div>two</div>");
      expect(utils.toHtml(d), equals("<div>one</div><div>two</div>"));
    });

    test('handles element when outer is false', () {
      var el = new DivElement()..innerHtml="content";
      expect(utils.toHtml(el, outer: false), equals("content"));
    });

    test('handles element when outer is true', () {
      var el = new DivElement()..innerHtml="content";
      expect(utils.toHtml(el, outer: true), equals("<div>content</div>"));
    });

    test('replaces all empty classes', () {
      final d = new DocumentFragment.html("<div class=\"\">content</div>");
      expect(utils.toHtml(d), equals("<div>content</div>"));
    });

    test('uses the given preprocessor', () {
      final d = new DivElement()..text = "input";
      final preprocessed = new DivElement()..text = "preprocessed";

      expect(utils.toHtml(d, preprocess: (_) => preprocessed), equals("preprocessed"));
    });
  });

  group("[elementText]", () {
    test('returns blank for comments', () {
      final c = new Comment("some data");
      expect(utils.elementText(c), equals(''));
    });

    test('handles shadow dom', () {
      var el = new DivElement();
      var shadow = el.createShadowRoot();
      shadow.innerHtml = 'content';

      expect(utils.elementText(el), equals('content'));
    });

    test('handles elements without children', () {
      var el = new DivElement()
        ..innerHtml = 'content';

      expect(utils.elementText(el), equals('content'));
    });

    test('handles elements with children', () {
      var el = new DivElement()
        ..innerHtml = '<div>one</div><div>two</div>';

      expect(utils.elementText(el), equals('onetwo'));
    });

    test('handles lists', () {
      var el1 = new DivElement()..innerHtml="one";
      var el2 = new DivElement()..innerHtml="two";

      expect(utils.elementText([el1, el2]), equals('onetwo'));
    });
  });
}