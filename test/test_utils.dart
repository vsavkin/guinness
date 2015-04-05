library guinness.test_utils;

import 'package:guinness/guinness.dart' as guinness;

final _context = new _DummyContext();

noop() {}

createSuite() => new guinness.Suite(_context);

createDescribe({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinness.Describe(
    name, parent, _context, func, exclusive: exclusive, excluded: excluded);

createIt({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinness.It(
    name, parent, func, exclusive: exclusive, excluded: excluded);

class _DummyContext implements guinness.Context {
  withDescribe(guinness.Describe describe, Function definition) {}
}
