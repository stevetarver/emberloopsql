import JSONAPIAdapter from 'ember-data/adapters/json-api';

export default JSONAPIAdapter.extend({
  host: 'http://localhost:3000',
  namespace: 'api',
  // change default naming scheme from daserize to camelize
  pathForType(type) {
    var camelized = Ember.String.camelize(type);
    return Ember.String.pluralize(camelized);
  }
});
