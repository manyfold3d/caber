# Caber

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/manyfold3d/caber/push.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/87209d996d4ffb7517c5/maintainability)](https://codeclimate.com/github/manyfold3d/caber/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/87209d996d4ffb7517c5/test_coverage)](https://codeclimate.com/github/manyfold3d/caber/test_coverage)
![Libraries.io dependency status for latest release](https://img.shields.io/librariesio/release/rubygems/caber)

![GitHub Release](https://img.shields.io/github/v/release/manyfold3d/caber)
![Gem Downloads (for latest version)](https://img.shields.io/gem/dtv/caber)
![Dependent repos (via libraries.io)](https://img.shields.io/librariesio/dependent-repos/rubygems/caber)

A simple [ReBAC](https://en.wikipedia.org/wiki/Relationship-based_access_control) / [Zanzibar](https://research.google/pubs/zanzibar-googles-consistent-global-authorization-system/) backend plugin for Rails apps. Allows you to easily specify permission relationships between pairs of objects, e.g. granting edit permission on a document to a specific user, like in Google Docs.

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
document.grant_permission_to "viewer", nil
```

### Relationships

In order to query lists of available objects, subjects need to be told what types they can be granted permission on. For each type, after including `Caber::Subject`, call `can_have_permissions_on` with the ActiveRecord class you want to be able to get lists of. `permitted_*` relationships are then automatically added for that type:

```
class User < ApplicationRecord
  include Caber::Subject
  can_have_permissions_on Document
end

user.permitted_documents
# => all documents with any granted permission

user.permitted_documents.with_permission "viewer"
# => all documents that the user has viewer permission on

user.permitted_documents.with_permission ["viewer", "editor"]
# => all documents that the user has viewer or editor permission on

```

The inverse relationship is also possible by specifying `can_grant_permissions_to` on objects:

```
class Document < ApplicationRecord
  include Caber::Object
  can_grant_permissions_to User
end

document.permitted_users
# => all users with any permission

document.permitted_users.with_permission "viewer"
# => all users with viewer permission

document.permitted_users.with_permission ["viewer", "editor"]
# => all users with viewer or editor permission

```

### Revoking permissions

You can revoke some or all permissions from a user:

```
# Remove a specific permission
document.revoke_permission("viewer", user)

# Remove all permissions from a user
document.revoke_all_permissions(user)
```

### Finding objects

You can get lists of objects that a user has some permission on:

```
Document.granted_to "viewer", user
# => All the documents that user has "viewer" permission on
```

## Usage with other gems

### Pundit

Caber makes for nice clear [Pundit](https://github.com/varvet/pundit) policies:

```
class DocumentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.granted_to(["viewer", "editor", "owner"], user)
    end
  end

  def update?
    record.grants_permission_to? ["editor", "owner"], user
  end
end
```

### Rolify

Caber doesn't include groups specifically, but you can integrate it easily with a role management gem like [Rolify](https://github.com/RolifyCommunity/rolify) pretty easily. Make your Role class a subject, and you can grant permissions to roles:

```
class Document < ApplicationRecord
  include Caber::Object
  can_grant_permissions_to Role
end

class Role < ApplicationRecord
  include Caber::Subject
  can_have_permissions_on Document

  scopify
end

document.grant_permission_to "editor", Role.find_by(name: "editor")

User.with_role(document.permitted_roles.with_permission("editor"))
# => all users with a role that can edit the document
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/manyfold3d/caber. This project is intended to be a safe, welcoming space for collaboration; everyone interacting in the Caber project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/manyfold3d/caber/blob/master/CODE_OF_CONDUCT.md).

## Acknowledgements

This gem was created as part of [Manyfold](https://manyfold.app), with funding from [NGI0 Entrust](https://nlnet.nl/entrust), a fund established by [NLnet](https://nlnet.nl) with financial support from the European Commission's [Next Generation Internet](https://ngi.eu) program.

[<img src="https://nlnet.nl/logo/banner.png" alt="NLnet foundation logo" width="20%" />](https://nlnet.nl)
[<img src="https://nlnet.nl/image/logos/NGI0_tag.svg" alt="NGI Zero Logo" width="20%" />](https://nlnet.nl/entrust)

Name: `"ReBAC".downcase.reverse`
