# How this project was made

## Basic directory strucure and framework init

A little goofiness here, working around each framework expecting to be in it's own directory named after the project...

With all dependencies installed:

```shell
$ mkdir emberloopsql && cd emberloopsql
$ ember init
$ mkdir frontend
$ cp * frontend/
$ git init
$ mkdir datastore
$ mkdir backend && cd backend
$ apic loopback
? What's the name of your application? emberloopsql
? Enter name of the directory to contain the project: backend
? What kind of application do you have in mind? empty-server (An empty LoopBack API, without any configured models or datasources)
    Created package.json
    Created serverod)
    Created server/boot
    Created server/boot/root.js
    Created server/config.json
    Created server/datasources.json
    Created server/middleware.json
    Created server/middleware.production.json
    Created server/model-config.json
    Created server/server.js
```

Ember provides a `.gitignore` for you - just ember taking care of its devels. As of 2.6.3, it no longer inits a git repo or makes the initial commit for you.

Create a backend `.gitignore` to exclude `node_modules/`.

Now wade through all the files, stage the ones you want, and create your first git commit.

## Datastore

First develop the scripts to stand up our datastore and seed data. Then we can develop the api and frontend.

A little magic here: I am using Docker for Mac v1.12.0-rc2; if this is new to you, it eliminates the previous docker-machine shenanigans and works just like a linux Docker - from the command line perspective.

The scripts are straight-forward with `initialize.sh` creating the percona container and seeding data. A start, stop, and restart script are provided for those not familiar with docker - this is now trivial with the removal of the need for docker-machines.

Commit the changes.

## Backend

With the database running, we can reverse engineer an API. 

I have used StrongLoop a couple of times before and I have a weird sort of appreciation; I like it because I don't really have to do much with it. You figure out a couple of tricks and the framework takes care of everything for you - assuming you have an application driven architecture where you can align your datastore contents with application needs. Then StrongLoop becomes configuration.

I took this opportunity to update to the IBM offering. Having to register an account and provide my phone number with IBM is a bit irksome, and they call it a trial, but if you check pricing, low volume use is free, perpetually. For that small inconvenience, I get the Essentials package, the only functionality I care about, for free. This allows me to start a browser, define a database connection, and then reverse engineer those contents. I get API doc and sandbox in the form of Swagger, and a complete API in about 15 minutes. A little refining via config edits and I will be ready to start the fun stuff - the front end.

IBM API Connect appears to be a Heroku on steriods; bridging the gap between cloud-native and the Enterprise. A lofty goal, but not a step I am ready to make but perhaps that's because of my current situation. If I were in a traditional enterprise, I would gladly pay to be out of that hell. But I have my own cloud platform to work in.

We already know we will need the MySQL datasource connector, so let's install that first.

```
npm install --save loopback-connector-mysql
```

From `backend/`: `apic edit` and a browser opens allowing you to sign into Bluemix. Create your account, sign in, and you are in the new StrongLoop ARC. The only trick to this part is to switch https to http and disable all the things that push to, or link to, Bluemix.

Where StrongLoop ARC was intuitive, API Connect has that needlessly complex feeling - kinda like developing in Java. Their help screens seem to confuse the flow. If you get to a main page, you will see 4 category tabs at the top of the page: Products, APIs, Models, and Data Sources. emberloopsql should show as a product. If you click the Data Sources tab, you can create a new Data Source with

- Name: emberloopsqldb
- Connector: MySQL
- Host: localhost
- Port: 3306
- User: root
- Password: root
- Database: application

When you save the connector config, apic will test the connection. The UI can be a bit quirky so if you fail to connect, delete the connector and re-enter it.

At top right is an icon with a page and magnifying glass - click it to start reverse engineering. This part seems much more refined than StrongLoop. Check the contacts schema, then the select button, and then generate and you have your first model.

Now click the APIs tab, the emberloopsql item and we can clean up the API; removing all the silly, non-ReST endpoints that StrongLoop is famous for. Why silly? They are non-standard. This means that we have to add extra frontend code to use them. The whole point of StrongLoop and Ember is to eliminate boilerplate code and these endpoints work against that goal. This part is also much improved over StrongLoop - you had to add code to the model code that suppressed the odd endpoints. Now we can just click a trashcan icon for

- /contacts/{id}/exists
- /contacts/findOne
- /contacts/update
- /contacts/count

We could take the time to walk through the API designer and change pretty much anything, but we'll assume there are sensible defaults and fix up outliers later. 

Another nice thing in the ui is you can toggle between a GUI API designer and the YAML it produces on the Source tab. This really shortens design changes over StrongLoop where you would guess or mine the docs for a code change. Here you can click a button with descriptions and then look at the source to see what changed. 

Not a big fan of YAML. I am always a bit confused about indentions, nesting, hyphens. This is the same reason that Docker moved away from YAML and created their own configuration language which is a JSON hybrid; just enough formatting to clearly indicate what belongs to what.

Click the save button and files on disk are updated and we can use the Explore menu item to jump into a completely different Swagger explorer. It provides language examples in 7 languages and curl. Makes me think of the Swagger code-gen vulnerability recently published. I think this is a step backwards in clarity and usability. The API listing has no hierarchical grouping so even with our reduced endpoint set, we have a list of 7 endpoints. If we had 10 tables in our app, there would be 70 which would be really tedious. Also, I don't need code examples for any of the provided languages - they all ignore the special frameworks developers would use in a real application. I would rather see the concise params and models as json like the plain old Swagger provides. Also, the response model definitions are not provided by default, and generating a test contact add is just not as good

By default, the Host is defined as `${catalog.host}` whose definition I could never find. I changed this to `localhost:3000` which fixed the API URL, but I never figured out how to run the API from the GUI. There is supposed to be a run button on the menu bar, but not showing for me.

So back to the command line to start the API and all data shows in a browser with `http://localhost:3000/api/contacts`.

Now I can call operations from the explorer but it is really slow. Slow loading definitions and slow parsing responses. In the browser, it took 83ms to return 45KB of contacts and a couple of seconds in the explorer.

Overall, it looks like some tasks will be easier, like modifying and updating the API and revising the API from datastore changes, but others have become more tedious, like general navigation and the whole Swagger experience. After an hour of playing with the GUI, I think I could repeat this exercise or a similar one in 15 minutes. Soon I will overlook the warts and inclusion in the Bluemix product and just see a really quick way to stand up datastore centric APIs.

Finally, we need to add the json:api component which makes Ember a dream to work in: related objects can be inferred by relationships links.

```
$ npm install --save loopback-component-jsonapi
```

Add a `server/component-config.json` file with the following to include the middleware component

```json
{
  "loopback-component-jsonapi": {}
}
```

This component is very configurable but the defaults work for me. But here's a trick: when we deploy, we will want to dynamically set our host name that will be used in json:api links. Leave `component-config.json` an empty object and use something like this in `component-config.local.js`

```javascript
module.exports = {   "loopback-component-jsonapi": {     "host": process.env.MY_URL   } }; ```
Now restart the loopback server and check out the response from `GET /api/contacts/5` - doesn't work.

```json
{
  "links": {
    "self": "http://localhost:3000/api/contacts/5"
  },
  "data": {
    "type": "contacts",
    "id": "5",
    "attributes": {
      "firstname": "Donette",
      "lastname": "Foller",
      "companyname": "Printing Dimensions",
      "address": "34 Center St",
      "city": "Hamilton",
      "county": "Butler",
      "state": "OH",
      "zip": "45011",
      "phone1": "513-570-1893",
      "phone2": "513-549-4561",
      "email": "donette.foller@cox.net",
      "website": "http://www.printingdimensions.com",
      "created": "2016-07-16T08:18:03.000Z",
      "modified": "2016-07-16T08:18:03.000Z"
    },
    "links": {
      "self": "http://localhost:3000/api/contacts/5"
    }
  }
}
```
If we were to add to this application by adding a company table, update our model config to show the contact-company relationship, there would be relationship links that tie the two together. In Ember templates, you can use `contact.company` and Ember will automatically fetch the associated company. Just think how much code that one feature eliminates...

That is all there is for this most basic config. All files are saved on disk so we can just close the API Connect window

## Frontend

Now that we have an API to build on, let's generate some well known components. This will be pretty simple, because the focus is a strategy for deploying the EmberLoopSql stack.

```shell
$ ember install ember-cli-sass
$ ember install ember-cli-bootstrap-sassy
$ ember generate adapter application
$ ember generate template application
$ ember generate template navbar
```

Set the `adapters/application.js` to connect to our API:

```javascript
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
```

Add bootstrap styles to our app: change `app/styles/app.css` to `app.scss` and add: `@import "bootstrap";`

The application template is where every page will be loaded - our Single Page Application - and should include the navbar and an outlet for generated code:

```html
<div>
  {{partial 'navbar'}}
  {{outlet}}
</div>
```

Create a standard bootstrap navbar in `navbar.hbs`. You can see the app by running `ember server`.

Except for installing new npm or bower components, we can just let Ember run and develop our app using livereload to display the changes. If you are new to Ember, and want to play with it, you should install the [Ember Inspector Chrome extension](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi?hl=en).

Just to add a little diversity, I added a Contacts navbar item to show all contacts. Let's setup the route, model, and templates up now.

```shell
$ ember g model contact
$ ember g route contacts/index
$ ember g route contacts/contact --path :contactId
```
which produces a router

```javascript
Router.map(function() {
  this.route('contacts', function() {
    this.route('contact', { path: ':contactId' });
  });
});
```
So we can very natually browse `/contacts/5` and get the expected results.

It also produces the index and detail templates for us.

First, flesh out the contact model - basically copy the attributes from the StrongLoop model and add datastore typing.

```javascript
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
```

In Ember, everything starts with a route, the route fetches the model and shoves it into a controller which provides it to a template. In this example, we are not adding controllers because we have no actions on the page. Ember will generate a suitable one for us.

So let's set up our routes to fetch the models. In the `contacts/index.js` route:

```javascript
import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.findAll('contact');
  }
});
```
The details route `contacts/:contactId` will extract the path variable and provide it as a param

```javascript
import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.store.findRecord('contact', params.contactId);
  }
});
```
Both of these statements are really cool.. that is all the code that is necessary to fetch data from the proper endpoint and serialize it into our contact model.

Now back to the templates to provide a list and detail display.

Ember templates are pretty clean and easy to read; everything that is dynamic is enclosed in `{{ }}`. The list page looks like

```html
<div class="container">

  <h2>Contacts</h2>

  <div class="table-responsive">
    <table class="table table-bordered table-striped">
      <thead>
        <tr>
          <th>#</th>
          <th>first name</th>
          <th>last name</th>
          <th>company name</th>
          <th>city</th>
          <th>state</th>
        </tr>
      </thead>
      <tbody>
        {{#each model as |m|}}
        <tr>
          <td>{{#link-to 'contacts.contact' m.id}}{{m.id}}{{/link-to}}</td>
          <td>{{m.firstname}}</td>
          <td>{{m.lastname}}</td>
          <td>{{m.companyname}}</td>
          <td>{{m.city}}</td>
          <td>{{m.state}}</td>
        </tr>
        {{/each}}
      </tbody>
    </table>
  </div>
</div>
```
