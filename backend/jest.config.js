module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/tests/**/*.js'],
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/app.js',
    '!src/config/**',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  setupFiles: ['<rootDir>/tests/setup.js'],
}; 