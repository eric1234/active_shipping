require 'test_helper'

class NotificationTest < Minitest::Test
  def test_validated_attribute
    notification = ActiveShipping::Notification.new

    notification.aggregation_type = :shipment

    assert_raises ArgumentError do
      notification.aggregation_type = :fake
    end
  end
end
