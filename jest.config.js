const config = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/setupTests.js'],
  testMatch: ["**/*.spec.js"]
};

module.exports = config;
