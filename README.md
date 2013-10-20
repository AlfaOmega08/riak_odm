# RiakOdm

RiakOdm is an Object-Document Mapping framework for Riak in Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'riak_odm'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install riak_odm

## Usage

It can be used in Rails and non-rails Applications. When using Rails, create your models in the app/models directory.

First of all, create a configuration file in config/riak_odm.yml like this:

    bucket:
      -
        host: 10.12.13.1
        port: 8087
      -
        host: 10.12.13.2
        port: 8087
      -
        host: 10.12.13.3
        port: 8087

You must specify the ProtocolBuffers port. riak_odm only supports the PB interface at the moment.

Every model need to include RiakOdm::Document. Riak can store any kind of binary data. By default riak_odm assumes
'application/json' Content-Type. This is the only type that supports fields. If you need to specify a different
Content-Type use the content_type method.

    class Picture
      include RiakOdm::Document

      content_type 'image/jpeg'
    end

The content_type will be set for all new documents. Documents fetched from the cluster will respect the reported
Content-Type. Also you can set per-document content_type with the same method.

'application/json' documents support fields:

    class Person
      include RiakOdm::Document

      #content_type 'application/json'     This is default
      field :name
      field :surname
    end

Now you can use the name, name=, surname and surname= accessors.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright © 2013 Francesco Boffa
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.