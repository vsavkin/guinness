part of guinness;

class Guinness {
  final GuinnessConfig config = new GuinnessConfig();
  Context _context = new Context();

  void resetContext([Context context]){
    _context = context == null ? new Context() : context;
  }

  SpyFunction createSpy([String name]) => new SpyFunction(name);

  SpyFunction spyOn(receiver, methodName) {
    throw ["spyOn not implemented"];
  }

  void runTests(){
    config.runner(_context.suite);
  }
}

class GuinnessConfig {
  Matchers matchers = new UnitTestMatchers();
  var runner = unitTestRunner;
}