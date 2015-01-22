module ARTest
  module SQLServer
    module CoerceableTest

      extend ActiveSupport::Concern

      included do
        cattr_accessor :coerced_tests, instance_accessor: false
        self.coerced_tests = []
      end

      module ClassMethods

        def coerce_tests!(*methods)
          methods.each do |method|
            self.coerced_tests.push(method)
            coerced_test_warning(method)
          end
        end

        def coerce_all_tests!
          once = false
          instance_methods(false).each do |method|
            next unless method.to_s =~ /\Atest/
            undef_method(method)
            once = true
          end
          STDOUT.puts "Info: Undefined all tests: #{self.name}"
        end

        private

        def coerced_test_warning(method)
          method = instance_methods(false).detect { |m| m =~ method } if method.is_a?(Regexp)
          result = undef_method(method) if method && method_defined?(method)
          STDOUT.puts "Info: Undefined coerced test: #{self.name}##{method}" unless result.blank?
        end

      end

    end
  end
end
