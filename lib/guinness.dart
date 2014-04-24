library guinness;

import 'package:unittest/unittest.dart' as unit;
import 'package:collection/equality.dart';
import 'dart:async' as async;
import 'dart:html';
import 'src/html_utils.dart' as htmlUtils;

part 'src/model.dart';
part 'src/context.dart';
part 'src/syntax.dart';
part 'src/matchers.dart';
part 'src/spy.dart';
part 'src/interfaces.dart';
part 'src/guinness_config.dart';
part 'src/unittest_backend/unittest_backend.dart';

class _Undefined{
  const _Undefined();
}
const _u = const _Undefined();

final Guinness guinness = new Guinness();