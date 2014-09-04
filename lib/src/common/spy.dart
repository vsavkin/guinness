part of guinness;

class SpyFunctionCall {
  final List positionalArguments;
  final Map namedArguments;
  SpyFunctionCall(this.positionalArguments, this.namedArguments);
}

@proxy
class SpyFunction {
  final String name;
  final List<SpyFunctionCall> calls = [];
  var _callFakeFn;

  SpyFunction(this.name);

  andCallFake(fn) {
    _callFakeFn = fn;
    return this;
  }

  call([a0=_u, a1=_u, a2 =_u, a3=_u, a4=_u, a5=_u]) =>
      _processCall(_takeDefined([a0, a1, a2, a3, a4, a5]), {});

  void reset() => calls.clear();

  num get count => calls.length;
  num get callCount => count;
  bool get called => count > 0;

  SpyFunctionCall get mostRecentCall {
    if (calls.isEmpty) throw ["No calls"];
    return calls.last;
  }

  firstArgsMatch([a0=_u, a1=_u, a2 =_u, a3=_u, a4=_u, a5=_u]) {
    final toMatch = _takeDefined([a0, a1, a2, a3, a4, a5]);
    if(calls.isEmpty) {
      return false;
    } else {
      Function eq = const ListEquality().equals;
      return eq(calls.first.positionalArguments, toMatch);
    }
  }

  _processCall(List posArgs, Map namedArgs) {
    calls.add(new SpyFunctionCall(posArgs, namedArgs));
    if(_callFakeFn != null){
      return Function.apply(_callFakeFn, posArgs, namedArgs);
    }
  }

  noSuchMethod(Invocation inv) =>
      inv.memberName == #call ?
        _processCall(inv.positionalArguments, _stringifyMap(inv.namedArguments)) :
        super.noSuchMethod(inv);
}

@proxy
class SpyObject {
  final Map<String, SpyFunction> _spyFuncs = {};

  noSuchMethod(Invocation inv) {
    final s = spy(_spyName(inv));
    return s._processCall(inv.positionalArguments, _stringifyMap(inv.namedArguments));
  }

  SpyFunction spy(String funcName) =>
      _spyFuncs.putIfAbsent(funcName, () => new SpyFunction(funcName));

  _spyName(Invocation inv) {
    final invName = mirrors.MirrorSystem.getName(inv.memberName);
    if (inv.isGetter) return "get:${invName}";
    if (inv.isSetter) return "set:${invName.substring(0, invName.length - 1)}";
    return invName;
  }
}

_stringifyMap(Map map) =>
    map.keys.fold({}, (res, c){
      res.putIfAbsent(mirrors.MirrorSystem.getName(c), () => map[c]);
      return res;
    });

List _takeDefined(List iter) => iter.takeWhile((_) => _ != _u).toList();