require 'rake'

module RevealCK
  module Builders
    # Given a location of reveal.js files, reveal-ck files, and slides
    # file to work with, and a place to put it all.. this class
    # creates a presentation.
    class SlidesBuilder
      include Config
      include RequiredArg
      include RakeAware
      attr_reader :reveal_js_dir, :revealck_dir
      attr_reader :slides_file, :output_dir
      attr_reader :application
      def initialize(args)
        @reveal_js_dir = retrieve(:reveal_js_dir, args)
        @revealck_dir = retrieve(:revealck_dir, args)
        @output_dir = retrieve(:output_dir, args)
        @slides_file = retrieve(:slides_file, args)
        @application = Rake::Application.new
        setup
      end

      def build
        application['create'].invoke
      end

      private

      def setup
        read_config
        task('create' => setup_dependencies)
      end

      def read_config
        config_file = File.join(@revealck_dir, 'config.yml')
        from_file(file: config_file) if File.exist?(config_file)
      end

      def setup_dependencies
        [setup_copy_user_files,
         setup_copy_reveal_js,
         setup_create_slides_html,
         setup_create_index_html]
      end

      def setup_copy_user_files
        task =
          CopyUserFiles.new(user_files_dir: revealck_dir,
                            output_dir: output_dir,
                            application: application)
        task.name
      end

      def setup_copy_reveal_js
        task =
          CopyRevealJs.new(reveal_js_dir: reveal_js_dir,
                           output_dir: output_dir,
                           application: application)
        task.name
      end

      def setup_create_slides_html
        task =
          CreateSlidesHtml.new(slides_file: slides_file,
                               config: self,
                               output_dir: output_dir,
                               application: application)
        task.name
      end

      def setup_create_index_html
        task =
          CreateIndexHtml.new(slides_html: "#{output_dir}/slides.html",
                              output_dir: output_dir,
                              config: self,
                              application: application)
        task.name
      end
    end
  end
end