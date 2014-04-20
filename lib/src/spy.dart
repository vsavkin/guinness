part of jasmine;

class Jasmine {
  createSpy([String name]) {
    return new SpyFunction(name);
  }

  SpyFunction spyOn(receiver, methodName) {
    throw ["spyOn not implemented"];
  }
}

class SpyFunctionInvocationResult {
  final List args;
  SpyFunctionInvocationResult(this.args);
}

@proxy
class SpyFunction {
  final String name;
  final List<List> invocations = [];
  var _callFakeFn;

  SpyFunction(this.name);

  andCallFake(fn) {
    _callFakeFn = fn;
    return this;
  }

  call([a0=_u, a1=_u, a2 =_u, a3=_u, a4=_u, a5=_u]) =>
      _processCall(_takeDefined([a0, a1, a2, a3, a4, a5]));

  noSuchMethod(Invocation c){
    if(c.memberName == #call){
      return _processCall(c.positionalArguments);
    } else {
      return super.noSuchMethod(c);
    }
  }

  void reset() => invocations.clear();

  num get count => invocations.length;
  num get callCount => count;
  bool get called => count > 0;

  SpyFunctionInvocationResult get mostRecentCall {
    if (invocations.isEmpty) {
      throw ["No calls"];
    }
    return new SpyFunctionInvocationResult(invocations.last);
  }

  firstArgsMatch([a0=_u, a1=_u, a2 =_u, a3=_u, a4=_u, a5=_u]){
    final toMatch = _takeDefined([a0, a1, a2, a3, a4, a5]);
    if(invocations.isEmpty){
      return false;
    } else {
      Function eq = const ListEquality().equals;
      return eq(invocations.first, toMatch);
    }
  }

  _processCall(List posArgs){
    invocations.add(posArgs);

    if(_callFakeFn != null){
      return Function.apply(_callFakeFn, posArgs);
    }
  }
}

class _Undefined{
  const _Undefined();
}
const _u = const _Undefined();
List _takeDefined(List iter) => iter.takeWhile((_) => _ != _u).toList();