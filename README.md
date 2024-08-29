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
document.grant_permission_to "viewer", user
```

You can query permissions in both directions:
```
document.grants_permission_to? "viewer", user
user.has_permission_on? "viewer", document
```

You can also check more than one permission at once by passing an array.
The check will be positive if *either* are granted:

```
document.grants_permission_to? ["viewer", "editor"], user
user.has_permission_on? ["viewer", "editor"], document
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

## Acknowledgements

This gem was created as part of [Manyfold](https://manyfold.app), with funding from [NGI0 Entrust](https://nlnet.nl/entrust), a fund established by [NLnet](https://nlnet.nl) with financial support from the European Commission's [Next Generation Internet](https://ngi.eu) program.

[<img src="https://nlnet.nl/logo/banner.png" alt="NLnet foundation logo" width="20%" />](https://nlnet.nl)
[<img src="https://nlnet.nl/image/logos/NGI0_tag.svg" alt="NGI Zero Logo" width="20%" />](https://nlnet.nl/entrust)
