part of guinness;

class Guinness {
  Context _context = new Context();
  Matchers matchers;
  SpecRunner _runner;
  SpecRunner _initSpecs;

  Guinness({this.matchers, SpecRunner runner, SpecRunner initSpecs})
      : _runner = runner, _initSpecs = initSpecs;

  SpyFunction createSpy([String name]) => new SpyFunction(name);

  void runTests(){
    _runner(_context.suite);
  }

  void initSpecs(){
    _initSpecs(_context.suite);
  }

  void resetContext([Context context]){
    _context = context == null ? new Context() : context;
  }
}