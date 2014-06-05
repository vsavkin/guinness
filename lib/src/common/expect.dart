part of guinness;

class Expect {
  final actual;
  Expect(this.actual);

  NotExpect get not => new NotExpect(actual);

  void to(matcher) => _m.expect(actual, matcher);
  void toEqual(expected) => _m.toEqual(actual, expected);
  void toContain(expected) => _m.toContain(actual, expected);
  void toBe(expected) => _m.toBe(actual, expected);

  /**
   * Checks that an object is a subtype of `expected`.
   *
   * # Examples
   *
   *    expect(new Employee()).toBeA(Employee);
   *    expect(new Employee()).toBeA(Person);
   */
  void toBeA(expected) => _m.toBeA(actual, expected);

  /**
   * Checks that an object is an instance of `expected`.
   *
   * # Examples
   *
   *    expect(new Employee()).toBeAnInstanceOf(Employee);
   *    expect(new Employee()).not.toBeAnInstanceOf(Person);
   */
  void toBeAnInstanceOf(expected) => _m.toBeAnInstanceOf(actual, expected);

  @Deprecated("toThrow() API is going to change to conform with toThrowWith()")
  void toThrow([message]) => _m.toThrow(actual, message);

  /**
   * Checks that `actual` throws an exception.
   *
   * When given parameters, additionally checks that:
   *
   * - anInstanceOf: the thrown exception is an instance of `anInstanceOf`.
   * - type: the thrown exception is a subtype of `type`.
   * - message: the thrown exception's message matches the provided pattern.
   * - where: the thrown exception matches all the expectations in the provided `where`.
   *
   * # Examples
   *
   *    expect(()=> throw "Invalid Argument").toThrowWith(message: "Invalid");
   *    expect(()=> throw new InvalidArgument()).toThrowWith(anInstanceOf: InvalidArgument);
   *    expect(()=> throw new InvalidArgument()).toThrowWith(type: ArgumentException);
   *    expect(()=> throw new InvalidArgument()).toThrowWith(where: (e) {
   *      expect(e).toBeAnInstanceOf(InvalidArgument)
   *    });
   */
  void toThrowWith({Type anInstanceOf, Type type, Pattern message, Function where}) =>
      _m.toThrowWith(actual, anInstanceOf: anInstanceOf, type: type, message: message, where: where);

  void toBeFalsy() => _m.toBeFalsy(actual);
  void toBeTruthy() => _m.toBeTruthy(actual);
  void toBeFalse() => _m.toBeFalse(actual);
  void toBeTrue() => _m.toBeTrue(actual);
  void toBeDefined() => _m.toBeDefined(actual);
  void toBeNull() => _m.toBeNull(actual);
  void toBeNotNull() => _m.toBeNotNull(actual);
  void toHaveBeenCalled() => _m.toHaveBeenCalled(actual);
  void toHaveBeenCalledOnce() => _m.toHaveBeenCalledOnce(actual);
  void toHaveBeenCalledWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      _m.toHaveBeenCalledWith(actual, a, b, c, d, e, f);
  void toHaveBeenCalledOnceWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      _m.toHaveBeenCalledOnceWith(actual, a, b, c, d, e, f);

  Matchers get _m => guinness.matchers;
}


class NotExpect {
  final actual;
  NotExpect(this.actual);

  void toEqual(expected) => _m.notToEqual(actual, expected);
  void toContain(expected) => _m.notToContain(actual, expected);
  void toBe(expected) => _m.notToBe(actual, expected);
  void toBeA(expected) => _m.notToBeA(actual, expected);
  void toBeAnInstanceOf(expected) => _m.notToBeAnInstanceOf(actual, expected);
  void toThrow() => _m.toReturnNormally(actual);
  void toBeDefined() => _m.toBeUndefined(actual);
  void toHaveBeenCalled() => _m.notToHaveBeenCalled(actual);
  void toHaveBeenCalledWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      _m.notToHaveBeenCalledWith(actual, a, b, c, d, e, f);

  Matchers get _m => guinness.matchers;
}