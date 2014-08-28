# v0.1.15

- The `where` argument to `toThrowWith` could be a function returning a boolean:

    `expect(testedClosure).toThrowWith(where: (e) => e is NoSuchMethodError);`

  will pass iff executing the `testClosure` throws a `NoSuchMethodError` exception.

# v0.1.14 (2014-08-02)

- Improve the handling of Shadow DOM. The `toHaveText` matcher now handles Shadow DOM with multiple insertion points.

# v0.1.13 (2014-07-21)

- Make the syntax more flexible by allowing passing any object as a name (e.g., `describe(MyClass, (){}`).
- Fixes a bug that caused some stack traces not to be preserved.

# v0.1.12 (2014-07-07)

- Add support for pending specs.

# v0.1.11 (2014-06-27)

- Add numeric matchers:
  - `toBeLessThan(expected)`,
  - `toBeGreaterThan(expected)`,
  - `toBeCloseTo(expected, precision)` - assert than the value is within `expected ± (10^-precision)/2`

# v0.1.10 (2014-06-23)

Handle afterEach blocks that throw.
- When both an `it` and an `afterEach` throw, the original error thrown by the `it` block is returned.
- When an `it` returns normally, and an `afterEach` throws, the error throw by the `afterEach` block is returned.


Add `init_specs.dart` to improve Karma integration. Since the standard auto initialization of specs does not work with Karma, you had to call `guinness.initSpecs()` manually.
Now you can just include the init file as follows:

    files: [
      "test/main1_test.dart",
      "test/main2_test.dart",
      "packages/guinness/init_specs.dart",
      {pattern: '**/*.dart', watched: true, included: false, served: true}
    ]


# v0.1.9 (2014-06-18)

Add extra information about the test suite.

Example:

    guinness.suiteInfo().activeItsPercent
    guinness.suiteInfo().exclusiveIts


# v0.1.8 (2014-06-11)

- Update the `toThrowWith` matcher to accept a callback to run custom matchers against the thrown exception
- Cleanup


# v0.1.7 (2014-06-02)

- Update the `toThrowWith` matcher to accept a pattern to match the message
- Update the `toThrowWith` matcher to accept the expected class of a thrown exception
- Add a `toBeAnInstanceOf(type)` matcher
- Add `toBeTrue` and `toBeFalse` matchers

The `toBeAnInstanceOf` matcher and the `anInstanceOf` parameter have been added because Dart2JS does not fully implement mirrors (in particular, it does not support `isSubtypeOf`, which is used by `toBeA` and `toThrowWith(type:)`). See API docs for more information.

# v0.1.6 (2014-05-28)

- Fix the `toThrowWith` matcher

# v0.1.5 (2014-05-27)

- Update the list of contributors
- Add a `toBeA(type)` matcher
- Add a `toThrowWith({type, message})` matcher
- Deprecate the `toThrow()` matcher (The API will change to conform with `toThrowWith()`)

# v0.1.4 (2014-05-20)

- License change

# v0.1.3 (2014-05-11)

- Add support for async `beforeEach`, `afterEach`, and `it` blocks.
- Add stats module. To enable: `guinness.showStats = true;`.
- Fix: `ddescribe` does not work when using the unittest backend.

# v0.1.2 (2014-05-03)

- Refactor the unittest backend.
- Add more tests for the unittest backend.

# v0.1.1 (2014-05-02)

- Fix type warnings.

# v0.1.0 (2014-05-02)

- Add an optional second argument to `expect` to make the unitest-to-guinness transition easier.
- Add `Expect#to` to run custom matchers.
- Change `spy` to match the Dart conventions, and enable handling named parameters in the future.
- Change the unittest backend to mimic Jasmine semantics (an exclusive `it` takes precedence).
- Rename `runTests` into `runSpecs`.
- Implement auto initialization, so there is no need to call `initSpec`.
- Split the library into the vm and browser versions.
- Implement new matchers.

#v0.0.1 (2014-04-24)

Initial release.

- Initial implementation of the Jasmine syntax (describe, it, beforeEach, afterEach).
- Initial implementation of matchers.
- Initial implementation of the main configuration object.

