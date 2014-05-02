require 'rake'

module RevealCK
  module Builders
    # Given a slides.html, a Rake application, and a place where the
    # final index.html file should end up, this class knows how to
    # work with Rake and create the index.html.
    class CreateIndexHtml
      include RequiredArg
      include RakeAware

      attr_reader :slides_html, :output_dir, :config
      attr_reader :application

      def initialize(args)
        @slides_file = retrieve(:slides_html, args)
        @output_dir = retrieve(:output_dir, args)
        @application = retrieve(:application, args)
        @config = retrieve(:config, args)
        setup
      end

      def name
        'create_index_html'
      end

      def setup
        index_html_file = "#{output_dir}/index.html"
        task(index_html_file => 'slides/slides.html') do
          IndexHtml.new(user_slides: "#{output_dir}/slides.html",
                        reveal_slides: "#{output_dir}/index.html",
                        config: config).build!
        end
        task(name => index_html_file)
      end
    end
  end
end