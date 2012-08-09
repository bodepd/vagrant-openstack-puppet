require "erb"

# Root ProjectRazor namespace
module ProjectRazor
  module ModelTemplate
    # Root Model object
    # @abstract
    class UbuntuPe < Ubuntu
      include(ProjectRazor::Logging)

      def initialize(hash)
        super(hash)
        # Static config
        @hidden = false
        @name = "ubuntu_precise_pe"
        @description = "Ubuntu Precise w/ PE Model"
        # Metadata vars
        @hostname_prefix = nil
        # State / must have a starting state
        @current_state = :init
        # Image UUID
        @image_uuid = true
        # Image prefix we can attach
        @image_prefix = "os"
        # Enable agent brokers for this model
        @broker_plugin = :agent
        @osversion = 'precise'
        @final_state = :os_complete
        from_hash(hash) unless hash == nil
      end

      def template_filepath(filename)
        filepath = File.join(File.dirname(__FILE__), "ubuntu/pe/#{filename}.erb")
      end

    end
  end
end
