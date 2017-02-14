# Describes the configuration for receiving e-mail notitification when
# generating a shipment/label. Based heavily on the options in Fedex so will
# likely be refactored as support is added for other providers.
class ActiveShipping::Notification

  module ValidatedAttrWriter
    def validated_attr_writer *methods
      methods.each do |method|
        define_method :"#{method}=" do |val|
          raise ArgumentError, "invalid #{method} type" unless
            self.class.const_get("#{method.upcase}S").include? val
          instance_variable_set :"@#{method}", val
        end
      end
    end
  end
  extend ValidatedAttrWriter

  class Recipient
    extend ValidatedAttrWriter

    TYPES = %i[shipper recipient broker third_party other]
    EVENT_TYPES = %i[delivery exception shipment tender]
    FORMATS = %i[html text]

    attr_accessor :email
    attr_reader :type, :event_type, :format
    validated_attr_writer :type, :event_type, :format

    def initialize
      @type = :recipient
      @event_type = :delivery
      @format = :html
    end
  end

  AGGREGATION_TYPES = %i[package shipment]

  attr_accessor :personal_message
  attr_reader :aggregation_type, :recipients
  validated_attr_writer :aggregation_type

  def initialize
    @recipients = []
  end
end
