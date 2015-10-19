# [PaaS Profiles](http://paasify.it)

*Making Platform as a Service offerings comparable - Ecosystem profiles for portability matching.*

<br/>
A no-standards approach for application portability.

Currently over 100 PaaS vendor profiles. Profiles are encoded as [JSON files](/profiles/).

**The web interface can be viewed at [PaaSify.it](http://paasify.it)**

**Any errors? Important missing properties? Suggestions? [Contribute](#contribution).**

## Contribution

I encourage **everyone** to submit corrections or additions in order to keep the profiles accurate and up-to-date.
In any case, please add evidence for the information so I can verify your changes.

I am also interested in direct **cooperation with vendors** in order to keep the profiles at first hand and spot-on. Contact me, if you are interested to supply a [vendor verified profile](#vendor-verification).

You can validate changes to the profiles via a simple test run, i.e., ```rake test``` that only requires a local MongoDB instance.  

Contribute either via [pull request](https://help.github.com/articles/using-pull-requests), create an [issue](https://github.com/stefan-kolb/paas-profiles/issues) or send me an [email](mailto:stefan.kolb@uni-bamberg.de).

### Minimal contribution

To add a PaaS please provide the info in JSON format in the folder
[`profiles`](/profiles/):

- `[paas-name].json`

See [below](#profile-specification) for details on the format
specification.

To include a logo for a PaaS you must provide it in 2 `.png` sizes in
the folder [`public/img/vendor`](/public/img/vendor):

- `[paas-name].png` in 80x80 px
- `[paas-name]_big.png` in 400x400 px

### Development

#### Preparing the environment

You might want to clone your own fork instead.

``` bash
git clone git@github.com:slipstream/paas-profiles.git
cd paas-profiles
gem install bundler # upgrade to the latest version of Bundler
bundle install
```

> **Note:** On some Ubuntu installations you might find following
> error about the MagickCore package:
> 
> ```
> Package MagickCore was not found in the pkg-config search path.
> (...)
> An error occurred while installing rmagick (2.15.4), and Bundler cannot continue.
> Make sure that `gem install rmagick -v '2.15.4'` succeeds before bundling.
> ```
> 
> In that case you might need to manually install `libmagickwand-dev`
> and `imagemagick` libraries, and relaunch the install:
> 
> ``` bash
> sudo apt-get install libmagickwand-dev imagemagick
> bundle install
> ```

#### Preparing the DB

To run the tests and a local instance of the application, you will
need an instance of MongoDB running. On Ubuntu you might want to
follow [this script][mongodb_gist] to install it, or
[this instructions][mongodb_c9] if you are on [c9.io].

[mongodb_gist]: https://gist.github.com/rbf/4001e6cc6d74465803f3
[mongodb_c9]: https://docs.c9.io/docs/setting-up-mongodb
[c9.io]: http://c9.io

Setup the following system variable with the DB endpoint:

``` bash
export MONGO_URL=127.0.0.1:27017
```

#### Locally launch the application

First you need to seed the database with

``` bash
rake db:seed
```

Then you can start the application with following command (from the
[`Procfile`](Procfile) file).

``` bash
bundle exec unicorn -p $PORT -c ./config/unicorn.rb
```

If you change the [JSON files](/profiles/), you can re-seed the DB
without having to restart the app.

#### Testing

As stated above, before sending a PR make sure that `rake test`
reports all green.

## Profile Specification

- [General Properties](#name)
- [Pricing](#pricing)
- [Quality of Service](#quality-of-service)
- [Hosting](#hosting)
- [Scaling](#scaling)
- [Runtimes](#runtimes)
- [Middleware](#middleware)
- [Frameworks](#frameworks)
- [Services](#services)
- [Infrastructures](#infrastructures)

The code below shows a sample profile. The profile specification is *beta* and the properties are subject to change. 

```json
{
  "name": "SomePaas",
  "revision": "2014-04-24",
  "vendor_verified": "2013-07-02",
  "url": "http://someurl.com",
  "status": "production",
  "status_since": "2012-07-15",
  "type": "Generic",
  "hosting": {
    "public": true, "private": false
  },
  "pricing": [
		{ "model": "fixed", "period": "monthly" }
  ],
  "qos": {
        "uptime": 99.8,
        "compliance": [
          "SSAE 16 Type II", "ISAE 3402 Type II"
        ]
  },
  "scaling": {
    "vertical": true, "horizontal": true, "auto": false
  },
  "runtimes": [
    { "language": "java", "versions": [ "1.7", "1.6" ] }
  ],
  "middleware": [
    { "name": "tomcat", "runtime": "java", "versions": [ "6.0.35" ] }
  ],
  "frameworks": [
	{ "name": "rails", "runtime": "ruby", "versions": [ "4.0.0" ] },
	{ "name": "django", "runtime": "python", "versions": [ "1.5.1" ] }
  ],
  "services": {
    "native": [
      { "name": "mongodb", "description": "", "type": "datastore", "versions": [ "1.8" ] }
    ],
    "addon": [
      { "name": "mongolab", "url": "https://mongolab.com/", "description": "", "type": "datastore" }
    ]
  },
  "extensible": false,
  "infrastructures": [
    { 
      "continent": "NA",
      "country": "US",
      "region": "Virginia",
      "provider": "AWS"
    }
  ]
}
```

### Name  

The official name of the PaaS offering.

### Revision

`Date` or `DateTime` of the profile's last update.
 
### Vendor Verification

This may be set to the `Date` when the profile was officially created or audited by the vendor.

### URL

The URL leading to the PaaS' webpage.

### Status

The current status of the offering. This may be one of the following lifecycle stages:

`alpha` = Work in progress or early test version  
`beta` = In private or public beta testing  
`production` = Live and generally available  
`eol` = Discontinued or integrated into another offering (End of life)

### Status Since

`Date` of the last status transition.

### Type

Positioning of the PaaS in between IaaS and SaaS. Currently allowed categories:

```
SaaS-centric, Generic, IaaS-centric
```

### Pricing

An array of all available billing options.

#### Model

The pricing model of the PaaS. Currently allowed values:
```
free, fixed, metered, hybrid
```
#### Period

The billing period. Currently allowed values:
```
daily, monthly, annually
```

Can be omitted if the pricing model is ```free```.

### Quality of Service

#### Uptime

The guaranteed monthly uptime by the provider.

#### Compliance

Currently a simple string array of compliance standards that are fulfilled by the PaaS.

### Hosting

An object that describes the different provided hosting styles of the PaaS.
Values can be `public` for a publicly hosted service and `private` for a service that can be deployed on premises, too.

### Scaling

An object including three boolean properties for characterizing the scaling capabilities:

`vertical` = Can you scale the instance sizes, e.g. ram?
`horizontal` = Can you scale the number of instances?
`auto` = Is the PaaS capable of scaling any of the above properties automatically?

### Runtimes

The runtimes an application can be written in. Defined as an array of objects.

```json
"runtimes": [
    { "language": "java", "versions": [ "1.7", "1.6" ] },
    { "language": "ruby", "versions": [ "1.9.3", "2.0.0" ] }
]
```

#### Language

This section must only include languages that are officially supported by the vendors.
Languages added via community buildpacks must not be added. Extensibility is modeled by the property *extensible*.
In order to allow exact matching, the language keys are restricted. Currently allowed keys are:

```
apex, clojure, cobol, dotnet, erlang, go, groovy, haskell, java, lua, node, perl, php, python, ruby, scala
```

*Note: Due to common parlance the Node framework is listed as language being the de facto standard for server-side scripting with JavaScript.*

#### Versions

A string array containing the supported runtime versions. Wildcards `*` may be used for branches or even marking all major versions as supported (e.g. `*.*`).

### Middleware

An array of *preinstalled or fully supported* middleware stacks.

```json
"middleware": [
    { "name": "tomcat", "runtime": "java", "versions": [ "6", "7" ] },
    { "name": "nginx", "versions": [ "1.6" ] }
]
```

#### Name

Should be the official name in lowercase. Currently not restricted.

#### Runtime

(Optional) The associated runtime of the middleware product.

#### Versions

A string array containing the supported middleware versions.

### Frameworks

An array of *officially and fully supported* frameworks.

```json
"frameworks": [
    { "name": "rails", "runtime": "ruby", "versions": [ "4.0.0" ] },
    { "name": "django", "runtime": "python", "versions": [ "1.5.1" ] }
]
```

#### Name

Should be the official name in lowercase. Currently not restricted.

#### Runtime

The associated runtime of the framework.

#### Versions

A string array containing the supported framework versions.

### Services

```json
"services": {
  "native": [
    { "name": "mongodb", "type": "datastore", "description": "", "versions": [ "1.8" ] }
  ],
  "addon": [
    { "name": "mongolab", "url": "https://mongolab.com/", "description": "", "type": "datastore" }
  ]
}
```

#### Native

Native services or core services are provided and hosted by the PaaS vendor as integral part of the offering. Most often this will be performance critical core services like datastores.

#### Add-on

Add-on services are provided by external vendors and may or may not be hosted in the same infrastructure as the PaaS. However, we only categorize services as add-ons if they can be provisioned directly from the PaaS and will be billed as additional part of the platform fee.

#### Type

A category the service does fit in. Currently allowed keys are:
*tbd* Maybe make it an array of types. 

```
datastore, search, worker, analytics, payment, media, messaging, other, devops
```

### Infrastructures

The infrastructures an application can be deployed to. Defined as an array of objects.

```json
"infrastructures": [
    { 
      "continent": "EU",
      "country": "IE",
      "region": "Dublin",
      "provider": "AWS"
    }
]
```

#### Continent

The continent must be encoded with the following continent codes:

```
AF = Africa, AS = Asia, EU = Europe, NA = North America, OC = Oceania, SA = South America
```

#### Country

The country codes must conform to the two-letter codes defined in [ISO 3166-1](http://en.wikipedia.org/wiki/ISO_3166-1).

#### Region

The property region can be used to further specify the location of the datacenter. This field is freeform and may specify a region or even the city the datacenter is located in.

#### Provider

This optional field may specify the name of the external IaaS provider used by the PaaS vendor, e.g. *Amazon Web Services*.

---
[![Build Status](https://travis-ci.org/stefan-kolb/paas-profiles.png)](https://travis-ci.org/stefan-kolb/paas-profiles)
[![Dependency Status](https://gemnasium.com/stefan-kolb/paas-profiles.png)](https://gemnasium.com/stefan-kolb/paas-profiles)
[![Code Climate](https://codeclimate.com/github/stefan-kolb/paas-profiles.png)](https://codeclimate.com/github/stefan-kolb/paas-profiles)