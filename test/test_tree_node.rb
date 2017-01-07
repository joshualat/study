require 'minitest/autorun'
require 'study'

class SampleClass
  attr_accessor :name, :age
  
  def initialize(name:, age:)
    @name = name
    @age = age
  end
end

class SampleClassWithLink
  attr_accessor :name, :age, :link
  
  def initialize(name:, age:)
    @name = name
    @age = age
  end
end

class TreeNodeTest < Minitest::Test
  def test_convert_symbol
    actual = Study::TreeNode.convert(:hello)
    expected = Study::TreeNode.new(type: "Symbol", value: :hello)

    assert_equal expected, actual
  end

  def test_convert_string
    actual = Study::TreeNode.convert("Hello")
    expected = Study::TreeNode.new(type: "String", value: "Hello")

    assert_equal expected, actual
  end

  def test_convert_fixnum
    actual = Study::TreeNode.convert(42)
    expected = Study::TreeNode.new(type: "Fixnum", value: 42)

    assert_equal expected, actual
  end

  def test_convert_float
    actual = Study::TreeNode.convert(42.0)
    expected = Study::TreeNode.new(type: "Float", value: 42.0)

    assert_equal expected, actual
  end

  def test_convert_hash
    actual = Study::TreeNode.convert({a: 1, b: 2, c: 3})
    expected = Study::TreeNode.new(
      type: "Hash", 
      value: {
        a: Study::TreeNode.new(type: "Fixnum", value: 1),
        b: Study::TreeNode.new(type: "Fixnum", value: 2),
        c: Study::TreeNode.new(type: "Fixnum", value: 3)
      }
    )

    assert_equal expected, actual
  end

  def test_convert_hash_with_strings_and_symbols
    actual = Study::TreeNode.convert({'a': 1, b: 2, c: 3})
    expected = Study::TreeNode.new(
      type: "Hash", 
      value: {
        b: Study::TreeNode.new(type: "Fixnum", value: 2),
        c: Study::TreeNode.new(type: "Fixnum", value: 3),
        a: Study::TreeNode.new(type: "Fixnum", value: 1)
      }
    )

    assert_equal expected, actual
  end

  def test_convert_array
    actual = Study::TreeNode.convert([1, 2, 3])
    expected = Study::TreeNode.new(
      type: "Array", 
      value: {
        0 => Study::TreeNode.new(type: "Fixnum", value: 1),
        1 => Study::TreeNode.new(type: "Fixnum", value: 2),
        2 => Study::TreeNode.new(type: "Fixnum", value: 3)
      }
    )

    assert_equal expected, actual
  end

  def test_object
    sample = SampleClass.new(name: "John Doe", age: 42)
    actual = Study::TreeNode.convert(sample)

    expected = Study::TreeNode.new(
      type: "SampleClass",
      value: {
        name: Study::TreeNode.new(type: "String", value: "John Doe"),
        age: Study::TreeNode.new(type: "Fixnum", value: 42)
      }
    )

    assert_equal expected, actual
  end

  def test_object_with_loop_detection
    a = SampleClassWithLink.new(name: "a", age: 1)
    b = SampleClassWithLink.new(name: "b", age: 2)
    c = SampleClassWithLink.new(name: "c", age: 3)

    a.link = b
    b.link = c
    c.link = a

    actual = Study::TreeNode.convert(a)

    expected = Study::TreeNode.new(
      type: "SampleClassWithLink",
      value: {
        name: Study::TreeNode.new(type: "String", value: "a"),
        age: Study::TreeNode.new(type: "Fixnum", value: 1),
        link: Study::TreeNode.new(
          type: "SampleClassWithLink",
          value: {
            name: Study::TreeNode.new(type: "String", value: "b"),
            age: Study::TreeNode.new(type: "Fixnum", value: 2),
            link: Study::TreeNode.new(
              type: "SampleClassWithLink",
              value: {
                name: Study::TreeNode.new(type: "String", value: "c"),
                age: Study::TreeNode.new(type: "Fixnum", value: 3),
                link: Study::TreeNode.new(
                  type: "SampleClassWithLink",
                  value: "DUPLICATE SampleClassWithLink"
                )
              }
            )
          }
        )
      }
    )

    assert_equal expected, actual
  end
end