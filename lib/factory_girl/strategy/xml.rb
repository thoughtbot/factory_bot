require 'nokogiri'

module FactoryGirl
  module Strategy
    class Create
      def association(runner)
        runner.run
      end

      def result(evaluation)
        evaluation.object.tap do |instance|
          evaluation.notify(:after_build, instance)
          evaluation.notify(:before_create, instance)
          evaluation.create(instance)
          evaluation.notify(:after_create, instance)
        end
      end
    end
  end
end


module FactoryGirl
  module Strategy
    class Xml

      def association(runner)
        runner.run(Strategy::Xml)
      end

      def result(evaluation)
        evaluation.object.tap do |instance|
          instance.extend XmlSerializeable
          instance.factory_xml_config.attributes.concat(evaluation.association_and_attribute_names)
          evaluation.notify(:after_build, instance)
        end
      end

      # proxy configuration
      def xml_config(&block)
        block.call(@instance.factory_xml_config)
      end

private

      class XmlConfig
        attr_accessor :attributes
        attr_reader :decoration_name

        def initialize
          @decorate_with_array  = false
          @attributes = []
        end

        def decorate_with_array(options = {})
          @decorate_with_array = true
          @decoration_name = options.delete(:name)
          @decorate_with_array = false if options.delete(:disable) == true
        end

        def decorate_with_array?
          @decorate_with_array
        end
      end
    end

public
    module XmlSerializeable

      def decoration_name
        factory_xml_config.decoration_name || instance_tag.pluralize
      end

      def instance_tag
        return @instance_tag if @instance_tag
        @instance_tag = self.tag_name if self.respond_to?(:tag_name)
        @instance_tag ||= self.class.name.split('::').last.downcase
      end

      def factory_xml_config
        @factory_xml_config ||=  FactoryGirl::Strategy::Xml::XmlConfig.new
      end

      def xml_config(&block)
        block.call(self.factory_xml_config)
      end

      def to_xml
        serializer = XmlSerializer.new(self).to_xml
      end

    end

private
    class XmlSerializer

      def initialize(instance)
        @instance = instance
      end

      # initialializes serialization of the instance
      def to_xml
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.root do
            serialize_object(xml, @instance)
          end
        end

        top_tag = @instance.factory_xml_config.decorate_with_array? ? @instance.decoration_name : @instance.instance_tag
        builder.doc.xpath("//#{top_tag}").to_xml
      end

private
      # the instance of the strategy is converted to xml
      def serialize_object(xml, object)

        # special case: instance itself is an array. kind of a hack
        if object.kind_of?(Enumerable)
          serialize_attribute(xml, object, nil)
          return
        end

        # convert all attributes to XML
        content = lambda do |parent|
          a_list = object.factory_xml_config.attributes
          a_list.each do |attribute|
            serialize_attribute(parent, object, attribute)
          end
        end

        # pack everything inside an array ?
        if object.factory_xml_config.decorate_with_array?
          decorate_with(xml, content, :decoration_name => object.decoration_name, :tag_name => object.instance_tag)
        else
          xml.send(object.instance_tag, &content)
        end
      end

      # serialize the attribute. Complex objects like factories (associations) or array will be serialized recursively
      def serialize_attribute(xml, object, attribute)
        if attribute.nil?

          # special case: instance itself is an array. kind of a hack
          value = object
          if object.respond_to?(:tag_name)
            attribute = object.tag_name
          else
            attribute = "array"
          end
        else
          value = object.send(:"#{attribute}")
        end

        if value.kind_of?(Enumerable)
          # arrays
          xml.send(attribute, :type => "array") do |array_xml|
            value.each do |array_element|
              serialize_object(array_xml, array_element)
            end
          end
        elsif value.kind_of?(XmlSerializeable)
          # factories
          serialize_object(xml, value)
        else
          # value objects
          tag_name = value.respond_to?(:tag_name) ? value.tag_name : attribute
          xml.send("#{tag_name}_", value)
        end
      end

      # creates an array-tag around the given block
      def decorate_with(builder, content_block, params)
        decoration_name = params.delete(:decoration_name)
        tag_name = params.delete(:tag_name)

        builder.send(decoration_name, :type => "array") do |around|
          around.send(tag_name, &content_block)
        end
      end
    end
  end
end
