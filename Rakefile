#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "udpate docs"
task :doc do
  puts %x{ yard --protected ./lib }
end

desc "udpate gh-pages"
task :pages do
  puts %x{ git checkout gh-pages && git merge master && git push }
  puts %x{ git checkout - }
end
