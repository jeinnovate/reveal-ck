# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

require 'rake/clean'

require_relative 'lib/reveal-ck'

desc 'Build slides.html'
file 'slides.html' => 'slides.haml' do
  processor = HamlProcessor.open 'slides.haml'
  File.open('slides.html', 'w') { |f| f << processor.html }
end

directory 'slides'
CLEAN.include 'slides'

REVEAL_FILES = FileList["reveal.js/**/*"]

desc 'Build presentation'
task :presentation => [ 'slides', 'slides.html'] do
  cp 'slides.html', 'slides'
  cp_r REVEAL_FILES, 'slides'
  line_nums = {
    default_slides: {
      first: 37,
      last: 338
    }
  }
  default_slides = line_nums[:default_slides][:first]..line_nums[:default_slides][:last]
  FileSlicer.slice! 'slides/index.html', default_slides
  FileSplicer.insert! 'slides.html', into: 'slides/index.html', after: '<div class="slides">'
end

task :default => :presentation
