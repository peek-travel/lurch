# Lurch [![Build Status](https://travis-ci.com/gadabout/lurch.svg?token=EE31hyxwr1Gpyes7CKcT&branch=master)](https://travis-ci.com/gadabout/lurch)

![lurch](https://cloud.githubusercontent.com/assets/5169/19086498/45d8db2a-8a23-11e6-8739-b37d0d8a6704.gif)

Start by creating a store:

```ruby
store = Lurch::Store.new(:url => 'http://example.com/api', :authorization => "Bearer #{token}")
```

## Fetching resources

```ruby
result = store.find_all(:contacts)
```

pagination metadata is on the result object:

```ruby
result.page      #=> 1
result.pages     #=> 2
result.per_page  #=> 50
result.count     #=> 75
```

coerce to array of resource objects; only gets the fetched page:

```ruby
result.data  #=> <first 50 contacts>
```

```ruby
result.each do |contact|
  #=> contact is a resource object
  #=> will iterate through all 75 contacts (causes second http request when first page is exhausted)
end
```

```ruby
next_page_result = result.next_page  #=> another result object for page 2
```

## Persisting resources

### updating an existing resource

```ruby
contact = store.find(Contact, 1)
changeset = Lurch::ChangeSet.new(contact, name: 'New Name')
changeset.update_attributes(email: 'new_email@example.com')

if store.save(changeset)
  contact.name  #=> 'New Name'
else
  # contact is unchanged
  changeset  #=> contains validation errors!
end
```

### create a new resource

```ruby
changeset = Lurch::ChangeSet.new(Contact, name: 'Name')
if new_contact = store.save(changeset)
  # new_contact.name => "name"
else
  # changest.errors = {"name" => [:messages => ['Already Taken!']]}
end
```

### delete a resource

```ruby
store.delete(contact)
```

## relationships

### fetching related resources

```ruby
contact.phone_numbers  #=> a relationship object (in this case has_many)
```

```ruby
# e.g.: relationship is a link
result = contact.phone_numbers.fetch # fetch relationship using link
# works just like any other result object
```

```ruby
# e.g.: relationship is resource identifiers
result = contact.phone_numbers.fetch
# acts like a result object, but will only have 1 page, and all resources
```

```ruby
# same object!
contact1 = store.find(:contacts, 1)
contact2 = store.find(Contact, 1)
```

### adding a new related resource to an existing resource

```ruby
changeset = Lurch::ChangeSet.new(PhoneNumber, number: '1112223344')
changeset.add_related(:contact, contact)
result = store.save(changeset)

new_phone_number = result.data
```

### relating two existing resources

```ruby
store.add_relationship(contact, :phone_numbers, [pn1, pn2])
store.add_relationship(phone_number, :contact, contact)
```

### delete relationship

```ruby
store.delete_relationship(contact, :phone_numbers, [pn1, pn2])
store.delete_relationship(phone_number, :contact, contact)
```
