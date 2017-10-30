# Lurch
[![Build Status](https://travis-ci.com/peek-travel/lurch.svg?token=EE31hyxwr1Gpyes7CKcT&branch=master)](https://travis-ci.com/peek-travel/lurch) [![Coverage Status](https://coveralls.io/repos/github/peek-travel/lurch/badge.svg?branch=master&t=I0oe5r)](https://coveralls.io/github/peek-travel/lurch?branch=master)

![lurch](https://cloud.githubusercontent.com/assets/221693/19378217/48fd6a9e-91a0-11e6-9085-3383efb20d72.gif)

A simple Ruby [JSON API](http://jsonapi.org/) client.

## Installation

Add this line to your application's Gemfile:

```
gem 'lurch'
```

And then execute:

```
$ bundle
```

Or install it yourself:

```
$ gem install lurch
```

## Basic Usage

Start by creating a store:

```ruby
store = Lurch::Store.new("http://example.com/api")
```

### Fetch resources from the server

GET individual resources from the server by id:

```ruby
person = store.from(:people).find("1")
#=> #<Lurch::Resource[Person] id: "1", name: "Bob">
```

Or GET all of them at once:

```ruby
people = store.from(:people).all
#=> [#<Lurch::Resource[Person] id: "1", name: "Bob">, #<Lurch::Resource[Person] id: "2", name: "Alice">]
```

`Lurch::Resource` objects have easy accessors for all attributes returned from the server:

```ruby
person.name
#=> "Bob"
person[:name]
#=> "Bob"
person.attributes[:name]
#=> "Bob"
```

But, `Lurch::Resource` objects are immutable:

```ruby
person.name = "Robert"
#=> NoMethodError: undefined method `name=' for #<Lurch::Resource:0x007fe62c848fb8>
```

### Update existing resources

To update an existing resource, create a changeset from the resource, then PATCH it to the server using the store:

```ruby
changeset = Lurch::Changeset.new(person, name: "Robert")
store.save(changeset)
#=> #<Lurch::Resource[Person] id: "1", name: "Robert">
```

Existing references to the resource will be updated:

```ruby
person.name
#=> "Robert"
```

### Create new resources

To create new resources, first create a changeset, then POST it to the server using the store:

```ruby
changeset = Lurch::Changeset.new(:person, name: "Carol")
new_person = store.insert(changeset)
#=> #<Lurch::Resource[Person] id: "3", name: "Carol">
```

## Filtering

You can add filters to your request if your server supports them:

```ruby
people = store.from(:people).filter(name: "Alice").all
#=> [#<Lurch::Resource[Person] id: "2", name: "Alice">]
```

## Relationships

Lurch can fetch *has-many* and *has-one* relationships from the server when they are provided as *related links*:

```ruby
person = store.from(:people).find("1")

person.hobbies
#=> #<Lurch::Relationship::Linked href: "http://example.com/api/people/1/friends">
person.hobbies.fetch
#=> #<Lurch::Collection[Hobby] size: 2, pages: 1>

person.best_friend
#=> #<Lurch::Relationship::Linked href: "http://example.com/api/people/1/best-friend">
person.best_friend.fetch
#=> #<Lurch::Resource[Person] id: "2", name: "Alice">
```

If the server provides the relationships as *resource identifiers* instead of links, you can get some information about the relationships without having to load them:

```ruby
person = store.from(:people).find("1")

person.hobbies
#=> [#<Lurch::Resource[Hobby] id: "1", not loaded>, ...]
person.hobbies.count
#=> 3
person.hobbies.map(&id)
#=> ["1", "2", "3"]
person.hobbies.map(&:name)
#=> Lurch::Errors::ResourceNotLoaded: Resource (Hobby) not loaded, try calling #fetch first.

person.best_friend
#=> #<Lurch::Resource[Person] id: "2", not loaded>
person.best_friend.id
#=> "2"
person.best_friend.name
#=> Lurch::Errors::ResourceNotLoaded: Resource (Person) not loaded, try calling #fetch first.
```

Regardless of what kind of relationship it is, it can be fetched from the server:

```ruby
person.best_friend.id
#=> "2"
person.best_friend.loaded?
#=> false
person.best_friend.fetch
#=> #<Lurch::Resource[Person] id: "2", name: "Alice">
person.best_friend.loaded?
#=> true
person.best_friend.name
#=> "Alice"
```

## Pagination

Lurch supports traversing and requesting paginated results if the server implements pagination:

```ruby
people = store.from(:people).all
#=> #<Lurch::Collection[Person] size: 1000, pages: 100>
```

If the server responded with meta data about the resources, you can get some information about them without loading them all:

```ruby
people.size
#=> 1000
people.page_count
#=> 100
```

*NOTE: This data comes from the top-level `meta` key in the jsonapi response document.  It assumes by default the keys are "record-count" and "page-count" respectively, but can be configured in the store.*

To request a specific page, use the page query method:

```ruby
people = store.from(:people).page(number: 12, size: 50).all
#=> #<Lurch::Collection[Person] size: 1000, pages: 20>
```

If you'd like to traverse the whole set, you can do that using the collection enumerator or the page enumerator:

```ruby
people.map(&:name)
# ...many HTTP requests later...
#=> ["Summer Brakus", "Katharina Orn", "Mr. Angus Hickle", "Collin Lowe PhD", "Kaylie Larson", ...]

people.each_page.map(&:size)
# ...many HTTP requests later...
#=> [10, 10, 10, 10, ...]
```

*NOTE: These enumerators can cause many HTTP requests to the server, since when it runs out of the first page of resources, it will automatically request the next page to continue.*

*TIP: Don't use `#count` on a collection to get its size.  Use `#size` instead.  `#count` causes the entire collection to be traversed, whereas `#size` will try and get the information from the collection meta data.*

You can also just get the resources from the current page as an array:

```ruby
people.resources
#=> [#<Lurch::Resource[Person] id: "2", name: "Summer Brakus", email: "summerb2b@kiehnhirthe.info", twitter: "@summerb2b">, ...]
```

## Authentication

You can add an *Authorization* header to all your requests by configuring the store:

```ruby
store = Lurch::Store.new("...", authorization: "Bearer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJzdWIiOjEsIm5hbWUiOiJCb2IifQ.")
```

## Contributing

1.  Fork it (<https://github.com/peek-travel/lurch/fork>)
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create a new Pull Request

## License

[MIT](LICENSE)
