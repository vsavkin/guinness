part of guinness;

class Guinness {
  Context _context = new Context();
  Matchers matchers;
  SpecRunner _runner;
  SpecRunner _initSpecs;
  bool autoInit = true;
  bool showStats = false;

  Guinness({this.matchers, SpecRunner runner, SpecRunner initSpecs})
      : _runner = runner, _initSpecs = initSpecs {

    _scheduleAutoInit();
  }

  SpyFunction createSpy([String name]) => new SpyFunction(name);

  SpyFunction spyOn(obj, String name) {
    throw "Not implemented";
  }

  void runSpecs() {
    _runner(_context.suite);
  }

  void initSpecs() {
    if(showStats) _printStats(_context.suite);
    _initSpecs(_context.suite);
  }

  void resetContext([Context context]) {
    _context = context == null ? new Context() : context;
  }

  void _scheduleAutoInit() {
    async.scheduleMicrotask((){
      if(autoInit)
        initSpecs();
    });
  }
}