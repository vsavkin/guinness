part of jasmine;

class Jasmine {
  final JasmineConfig config = new JasmineConfig();
  Context _context = new Context();
  void resetContext([Context context]){
    _context = context == null ? new Context() : context;
  }

  SpyFunction createSpy([String name]) => new SpyFunction(name);

  SpyFunction spyOn(receiver, methodName) {
    throw ["spyOn not implemented"];
  }
}

class JasmineConfig {
  Matchers matchers = new UnitTestMatchers();
}