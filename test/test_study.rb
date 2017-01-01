require 'minitest/autorun'
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

class StudyTest < Minitest::Test
  def assert_outputs(expected)
    out, _err = capture_io do
      yield
    end

    assert_equal expected, out
  end

  def build_string(params)
    (params + [""]).map { |line| line + "\n" }.join
  end

  def test_study_string
    expected = "String Hello\n"

    assert_outputs(expected) do
      study("Hello", plain: true)
    end
  end

  def test_study_symbol
    expected = "Symbol test\n"

    assert_outputs(expected) do
      study(:test, plain: true)
    end
  end

  def test_study_fixnum
    expected = "Fixnum 42\n"

    assert_outputs(expected) do
      study(42, plain: true)
    end
  end

  def test_study_float
    expected = "Float 42.0\n"

    assert_outputs(expected) do
      study(42.0, plain: true)
    end
  end

  def test_study_hash
    expected = build_string([
      "Hash",
      "   ├── a: 1",
      "   ├── b: 2",
      "   └── c: 3"
    ])

    assert_outputs(expected) do
      study({
        a: 1, 
        b: 2, 
        c: 3
      }, 
      plain: true)
    end
  end

  def test_study_array
    expected = build_string([
      "Array",
      "   ├── 0: a",
      "   ├── 1: b",
      "   ├── 2: c",
      "   ├── 3: d",
      "   └── 4: e"
    ])

    assert_outputs(expected) do
      study([
        "a",
        "b",
        "c",
        "d",
        "e"
      ], 
      plain: true)
    end
  end

  def test_study_class_with_children
    expected = build_string([
      "SampleClassWithChildren",
      "   ├── age: 1",
      "   ├── children: Array",
      "   │   ├── 0: SampleClassWithChildren",
      "   │   │   ├── age: 2",
      "   │   │   ├── name: b",
      "   │   │   └── state: unlocked",
      "   │   │",
      "   │   └── 1: SampleClassWithChildren",
      "   │       ├── age: 3",
      "   │       ├── name: c",
      "   │       └── state: unlocked",
      "   │    ",
      "   ├── name: a",
      "   └── state: unlocked"
    ])

    assert_outputs(expected) do
      a = SampleClassWithChildren.new(name: "a", age: 1)
      b = SampleClassWithChildren.new(name: "b", age: 2)
      c = SampleClassWithChildren.new(name: "c", age: 3)

      a.children = [b, c]

      study(a, plain: true)
    end
  end

  def test_study_class_with_grandchildren
    expected = build_string([
      "SampleClassWithChildren",
      "   ├── age: 1",
      "   ├── children: Array",
      "   │   ├── 0: SampleClassWithChildren",
      "   │   │   ├── age: 2",
      "   │   │   ├── children: Array",
      "   │   │   │   └── 0: SampleClassWithChildren",
      "   │   │   │       ├── age: 4",
      "   │   │   │       ├── children: Array",
      "   │   │   │       │   ├── 0: SampleClassWithChildren",
      "   │   │   │       │   │   ├── age: 5",
      "   │   │   │       │   │   ├── name: e",
      "   │   │   │       │   │   └── state: unlocked",
      "   │   │   │       │   │",
      "   │   │   │       │   └── 1: SampleClassWithChildren",
      "   │   │   │       │       ├── age: 6",
      "   │   │   │       │       ├── name: f",
      "   │   │   │       │       └── state: unlocked",
      "   │   │   │       │    ",
      "   │   │   │       ├── name: d",
      "   │   │   │       └── state: unlocked",
      "   │   │   │    ",
      "   │   │   ├── name: b",
      "   │   │   └── state: unlocked",
      "   │   │",
      "   │   └── 1: SampleClassWithChildren",
      "   │       ├── age: 3",
      "   │       ├── name: c",
      "   │       └── state: unlocked",
      "   │    ",
      "   ├── name: a",
      "   └── state: unlocked"
    ])

    assert_outputs(expected) do
      a = SampleClassWithChildren.new(name: "a", age: 1)
      b = SampleClassWithChildren.new(name: "b", age: 2)
      c = SampleClassWithChildren.new(name: "c", age: 3)
      d = SampleClassWithChildren.new(name: "d", age: 4)
      e = SampleClassWithChildren.new(name: "e", age: 5)
      f = SampleClassWithChildren.new(name: "f", age: 6)

      a.children = [b, c]
      b.children = [d]
      d.children = [e, f]

      study(a, plain: true)
    end
  end

  def test_study_class_with_grandchildren_detect_loops_and_duplicates
    expected = build_string([
      "SampleClassWithChildren",
      "   ├── age: 1",
      "   ├── children: Array",
      "   │   ├── 0: SampleClassWithChildren",
      "   │   │   ├── age: 2",
      "   │   │   ├── children: Array",
      "   │   │   │   └── 0: SampleClassWithChildren",
      "   │   │   │       ├── age: 4",
      "   │   │   │       ├── children: Array",
      "   │   │   │       │   ├── 0: SampleClassWithChildren",
      "   │   │   │       │   │   ├── age: 5",
      "   │   │   │       │   │   ├── name: e",
      "   │   │   │       │   │   └── state: unlocked",
      "   │   │   │       │   │",
      "   │   │   │       │   └── 1: SampleClassWithChildren",
      "   │   │   │       │       ├── age: 6",
      "   │   │   │       │       ├── children: Array",
      "   │   │   │       │       │   └── 0: DUPLICATE SampleClassWithChildren",
      "   │   │   │       │       │",
      "   │   │   │       │       ├── name: f",
      "   │   │   │       │       └── state: unlocked",
      "   │   │   │       │    ",
      "   │   │   │       ├── name: d",
      "   │   │   │       └── state: unlocked",
      "   │   │   │    ",
      "   │   │   ├── name: b",
      "   │   │   └── state: unlocked",
      "   │   │",
      "   │   └── 1: SampleClassWithChildren",
      "   │       ├── age: 3",
      "   │       ├── name: c",
      "   │       └── state: unlocked",
      "   │    ",
      "   ├── name: a",
      "   └── state: unlocked"
    ])

    assert_outputs(expected) do
      a = SampleClassWithChildren.new(name: "a", age: 1)
      b = SampleClassWithChildren.new(name: "b", age: 2)
      c = SampleClassWithChildren.new(name: "c", age: 3)
      d = SampleClassWithChildren.new(name: "d", age: 4)
      e = SampleClassWithChildren.new(name: "e", age: 5)
      f = SampleClassWithChildren.new(name: "f", age: 6)

      a.children = [b, c]
      b.children = [d]
      d.children = [e, f]

      f.children = [a]

      study(a, plain: true)
    end
  end
end