require 'test/test_helper' 

class MockController < ApplicationController
end

class ControllerHelpersTest < ActionController::TestCase

  def setup
    @controller = MockController.new
  end

  tests MockController

  test "order_by_from with sidx and sord" do
    params = {'sidx' => 'updated_at', 'sord' => 'desc' }
    assert_equal 'updated_at desc', @controller.order_by_from_params(params)
  end

  test "order_by_from with sidx" do
    params = {'sidx' => 'updated_at'}
    assert_equal 'updated_at', @controller.order_by_from_params(params)
  end

  test "order_by_from without sidx" do
    params = {'sord' => 'desc' }
    assert_nil @controller.order_by_from_params(params)
  end

  test "order_by_from with blank sidx" do
    params = {'sidx' => ''}
    assert_nil @controller.order_by_from_params(params)
  end

  test "json_for_grid with empty records result" do
    records = Invoice.paginate(:page => 1)
    assert_equal '{"total":0,"rows":[],"page":1,"records":0}', @controller.json_for_jqgrid(records)
  end

  test "json_for_grid with one record" do
    tmp_record  = Invoice.create({:invid => 1, :invdate => '2011-01-01 00:00:00', :amount => 10, :tax => 1, :total => 11, :note => '' })
    records     = Invoice.paginate(:page => 1)
    expected    = '{"total":1,"rows":[{"cell":["2011-01-01T00:00:00Z",10.0,11.0],"id":"2011-01-01T00:00:00Z"}],"page":1,"records":1}'
    Invoice.delete(tmp_record.id)
    assert_equal expected, @controller.json_for_jqgrid(records, ['invdate', 'amount', 'total' ])
  end


end
