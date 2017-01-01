require_relative './examples_helper'
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

def main
  run_example "Fixnum" do
    study 5
  end

  run_example "Class with Children" do
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

    study a
  end
end

main