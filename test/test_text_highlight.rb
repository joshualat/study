require 'minitest/autorun'
require 'study'

class TextHighlightTest < Minitest::Test
  def assert_outputs(expected)
    out, _err = capture_io do
      yield
    end

    assert_equal expected, out
  end

  def test_red
    assert_equal "\e[1;31;40mtest\e[0m", Study::TextHighlight.red("test")
  end

  def test_yellow
    assert_equal "\e[1;33;40mtest\e[0m", Study::TextHighlight.yellow("test")
  end

  def test_blue
    assert_equal "\e[1;34;40mtest\e[0m", Study::TextHighlight.blue("test")
  end

  def test_green
    assert_equal "\e[1;32;40mtest\e[0m", Study::TextHighlight.green("test")
  end

  def test_violet
    assert_equal "\e[1;35;40mtest\e[0m", Study::TextHighlight.violet("test")
  end

  def test_cyan
    assert_equal "\e[1;36;40mtest\e[0m", Study::TextHighlight.cyan("test")
  end

  def test_white
    assert_equal "\e[1;37;40mtest\e[0m", Study::TextHighlight.white("test")
  end

  def test_plain_red
    assert_outputs("test\n") do
      puts Study::TextHighlight.red("test", plain: true)
    end
  end

  def test_plain_yellow
    assert_outputs("test\n") do
      puts Study::TextHighlight.yellow("test", plain: true)
    end
  end

  def test_plain_blue
    assert_outputs("test\n") do
      puts Study::TextHighlight.blue("test", plain: true)
    end
  end

  def test_plain_green
    assert_outputs("test\n") do
      puts Study::TextHighlight.green("test", plain: true)
    end
  end

  def test_plain_violet
    assert_outputs("test\n") do
      puts Study::TextHighlight.violet("test", plain: true)
    end
  end

  def test_plain_cyan
    assert_outputs("test\n") do
      puts Study::TextHighlight.cyan("test", plain: true)
    end
  end

  def test_plain_white
    assert_outputs("test\n") do
      puts Study::TextHighlight.white("test", plain: true)
    end
  end
end