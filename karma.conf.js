module.exports = function(config) {
  config.set({
    basePath: '.',
    frameworks: ['dart-unittest'],

    files: [
      'test/guinness_test.dart',
      'test/html_utils_test.dart',
      {pattern: '**/*.dart', watched: true, included: false, served: true}
    ],

    exclude: [
    ],

    autoWatch: true,
    captureTimeout: 20000,
    browserNoActivityTimeout: 300000,

    plugins: [
      'karma-dart',
      'karma-chrome-launcher'
    ],

    browsers: ['Dartium']
  });
};
