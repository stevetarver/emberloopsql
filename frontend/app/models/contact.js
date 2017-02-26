import Model from 'ember-data/model';
import attr from 'ember-data/attr';
// import { belongsTo, hasMany } from 'ember-data/relationships';

export default Model.extend({
    firstname: attr('string'),
    lastname: attr('string'),
    companyname: attr('string'),
    address: attr('string'),
    city: attr('string'),
    country: attr('string'),
    state: attr('string'),
    zip: attr('string'),
    phone1: attr('string'),
    phone2: attr('string'),
    email: attr('string'),
    created: attr('date'),
    modified: attr('date'),
});
