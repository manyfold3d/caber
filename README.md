# Caber

A simple ReBAC / Zanzibar gem for Rails apps.

## Installation

Add caber to your Rails application's Gemfile:

```
bundle add caber
```

Then, run the installer:

```
rails g caber:install
```

This will create an initializer and a migration to add the `caber_relations` to your database.

Set up the permission types you want in the `config/initializers/caber.rb` file - a default is provided, but you can change it to whatever combination of permissions you'd like.

## Usage

To use Caber, include `Caber::Subject` in any of your models that can be given permissions (e.g. Users), and include `Caber::Object` in the things that subjects are given permission TO (e.g. documents):

```
class User < ApplicationRecord
  include Caber::Subject
end

class Document < ApplicationRecord
  include Caber::Object
end
```

Now you're ready to grant some permissions! To give someone permission on something:

```
document.grant_permission_to :view, user
```

You can query permissions in both directions:
```
document.grants_permission_to? :view, user
user.has_permission_to? :view, document
```

### Global permissions

To grant or query permissions globally (for instance, for a public view permission), you can use a `nil` subject:

```
document.grant_permission_to :view, nil
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/manyfold3d/caber. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Caber project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/manyfold3d/caber/blob/master/CODE_OF_CONDUCT.md).
