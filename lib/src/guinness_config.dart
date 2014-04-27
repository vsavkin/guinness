part of guinness;

class Guinness {
  Context _context = new Context();
  Matchers matchers;
  SpecRunner runner;

  Guinness({this.matchers, this.runner});

  SpyFunction createSpy([String name]) => new SpyFunction(name);

  void runTests(){
    runner(_context.suite);
  }

  void resetContext([Context context]){
    _context = context == null ? new Context() : context;
  }
}