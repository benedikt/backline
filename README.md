# Backline

Backline is versioned data storage based on Git.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'backline'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install backline

## Usage

```ruby
class Dummy
  include Backline::Model

  attribute :foo
end

repository = Backline::Repository.create('testing') do |r|
  r.register(Dummy)
end

model = Dummy.new(id: '1', foo: Time.now.to_s)

repository.transaction do |transaction|
  transaction.save(model)
end

repository.find(Dummy, '1')
# => #<Dummy:0x007f90eab2f200 @attributes={"foo"=>"2015-01-07 16:09:36 +0100"}, @id="1">

repository.all(Dummy) 
# => [#<Dummy:0x007f90eaa7c330 @attributes={"foo"=>"2015-01-07 16:09:36 +0100"}, @id="1">]
```

## Contributing

1. Fork it ( https://github.com/benedikt/backline/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
