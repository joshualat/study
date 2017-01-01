Study (study)
=======================================

Study Ruby objects, hashes, and arrays by exposing their internal structure with trees, colors, and indentation

## Installation

Study (study) is available as a RubyGem:

```bash
$ gem install study
```

### Gemfile

~~~ ruby
...

gem 'study', :group => :development

...
~~~

Basic usage
-----------
~~~ ruby
require 'study'

class SampleClassWithChildren
  attr_accessor :name, :age, :children
  attr_reader :state
  
  def initialize(name:, age:)
    @name = name
    @age = age
    @state = :unlocked
  end

  def lock!
    @state = :locked
  end
end

a = SampleClassWithChildren.new(name: "a", age: 1)
b = SampleClassWithChildren.new(name: "b", age: 2)
c = SampleClassWithChildren.new(name: "c", age: 3)
d = SampleClassWithChildren.new(name: "d", age: 4)
e = SampleClassWithChildren.new(name: "e", age: 5)
f = SampleClassWithChildren.new(name: "f", age: 6)

a.children = [b, c]
b.children = [d]
d.children = [e, f]
f.children = [a] # points to root

study(a)

# without colors
study(a, plain: true)
~~~

### Output

~~~ ruby
SampleClassWithChildren
   ├── age: 1
   ├── children: Array
   │   ├── 0: SampleClassWithChildren
   │   │   ├── age: 2
   │   │   ├── children: Array
   │   │   │   └── 0: SampleClassWithChildren
   │   │   │       ├── age: 4
   │   │   │       ├── children: Array
   │   │   │       │   ├── 0: SampleClassWithChildren
   │   │   │       │   │   ├── age: 5
   │   │   │       │   │   ├── name: e
   │   │   │       │   │   └── state: unlocked
   │   │   │       │   │
   │   │   │       │   └── 1: SampleClassWithChildren
   │   │   │       │       ├── age: 6
   │   │   │       │       ├── children: Array
   │   │   │       │       │   └── 0: DUPLICATE SampleClassWithChildren
   │   │   │       │       │
   │   │   │       │       ├── name: f
   │   │   │       │       └── state: unlocked
   │   │   │       │    
   │   │   │       ├── name: d
   │   │   │       └── state: unlocked
   │   │   │    
   │   │   ├── name: b
   │   │   └── state: unlocked
   │   │
   │   └── 1: SampleClassWithChildren
   │       ├── age: 3
   │       ├── name: c
   │       └── state: unlocked
   │    
   ├── name: a
   └── state: unlocked

~~~

Advanced Usage
--------------

`Study` can be used to study the nested results of API Responses.

~~~ ruby
require 'study'
require 'paypal-sdk-rest'

paypal_client_id = "..."
paypal_client_secret = "..."

PayPal::SDK.configure(
  :mode => "sandbox",
  :client_id => paypal_client_id,
  :client_secret => paypal_client_secret,
  :ssl_options => { } 
)

payment_history = PayPal::SDK::REST::Payment.all(count: 3)

study(payment_history)
~~~

### Output

~~~ ruby
PayPal::SDK::REST::DataTypes::PaymentHistory
   ├── count: 3
   ├── error: nil
   ├── next_id: PAY-9YN19841DE7833935LBTY2NQ
   └── payments: PayPal::SDK::Core::API::DataTypes::ArrayWithBlock
       ├── 0: PayPal::SDK::REST::DataTypes::Payment
       │   ├── create_time: 2016-12-31T13:06:26Z
       │   ├── error: nil
       │   ├── id: PAY-74V54223LK816733HLBT22UQ
       │   ├── intent: authorize
       │   ├── links: PayPal::SDK::Core::API::DataTypes::ArrayWithBlock
       │   │   └── 0: PayPal::SDK::REST::DataTypes::Links
       │   │       ├── error: nil
       │   │       ├── href: https://api.sandbox.paypal.com/...
       │   │       ├── method: GET
       │   │       └── rel: self
       │   │    
       │   ├── payer: PayPal::SDK::REST::DataTypes::Payer
       │   │   ├── error: nil
       │   │   ├── payer_info: PayPal::SDK::REST::DataTypes::PayerInfo
       │   │   │   ├── email: paypal-sample-buyer@gmail.com
       │   │   │   ├── error: nil
       │   │   │   ├── first_name: Buyer
       │   │   │   ├── last_name: PayPal
       │   │   │   ├── payer_id: ASUAXK674N7QW
       │   │   │   └── shipping_address: PayPal::SDK::REST...
       │   │   │       ├── city: San Jose
       │   │   │       ├── country_code: US
       │   │   │       ├── error: nil
       │   │   │       ├── line1: 1 Main St
       │   │   │       ├── postal_code: 95131
       │   │   │       ├── recipient_name: Buyer PayPal
       │   │   │       └── state: CA
       │   │   │    
       │   │   ├── payment_method: paypal
       │   │   └── status: VERIFIED
       │   │
       │   ├── state: approved
       │   ├── transactions: PayPal::SDK::Core::API::DataTypes::ArrayWithBlock
       │   │   └── 0: PayPal::SDK::REST::DataTypes::Transaction
       │   │       ├── amount: PayPal::SDK::REST::DataTypes::Amount
       │   │       │   ├── currency: USD
       │   │       │   ├── details: PayPal::SDK::REST::DataTypes::Details
       │   │       │   │   ├── error: nil
       │   │       │   │   └── subtotal: 1.00
       │   │       │   │
       │   │       │   ├── error: nil
       │   │       │   └── total: 1.00

(and so on)
~~~

License
-------
Copyright (c) 2016-2017 Joshua Arvin Lat

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.