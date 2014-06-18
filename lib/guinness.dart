library guinness;

import 'package:unittest/unittest.dart' as unit;
import 'package:collection/equality.dart';
import 'dart:async' as async;
import 'dart:mirrors' as mirrors;

part 'src/common/model.dart';
part 'src/common/context.dart';
part 'src/common/syntax.dart';
part 'src/common/expect.dart';
part 'src/common/spy.dart';
part 'src/common/interfaces.dart';
part 'src/common/guinness_config.dart';
part 'src/common/unittest_backend.dart';
part 'src/common/exclusive_visitor.dart';
part 'src/common/suite_info.dart';

class _Undefined {
  const _Undefined();
}
const _u = const _Undefined();

final Guinness guinness = new Guinness(
    matchers: new UnitTestMatchers(),
    runner: unitTestRunner,
    initSpecs: unitTestInitSpecs);