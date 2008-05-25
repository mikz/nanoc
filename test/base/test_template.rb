require 'helper'

class Nanoc::TemplateTest < Test::Unit::TestCase

  def setup    ; global_setup    ; end
  def teardown ; global_teardown ; end

  def test_initialize
    # Make sure attributes are cleaned
    template = Nanoc::Template.new('content', { 'foo' => 'bar' }, 'sample')
    assert_equal({ :foo => 'bar' }, template.page_attributes)
  end

end