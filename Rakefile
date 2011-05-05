require 'rubygems'  
require 'rake'  

begin  
  require 'jeweler'  
  Jeweler::Tasks.new do |gemspec|  
    gemspec.name = "post_office"  
    gemspec.summary = "PostOffice mock SMTP/POP3 server"  
    gemspec.description = "PostOffice mock SMTP/POP3 server"  
    gemspec.email = "rene@bluerail.nl"
    gemspec.homepage = "http://github.com/bluerail/post_office"
    gemspec.description = "A mock SMTP/POP3 server to aid in the development of applications with mail functionality."
    gemspec.authors = ["Rene van Lieshout"]  
    gemspec.bindir = "bin"
    gemspec.executables = ['post_office', 'post_officed']
  end  
rescue LoadError  
  puts "Jeweler not available. Install it with: sudo gem install jeweler" 
end  

namespace :startup_item do
  desc "Installs Post Office Mac OS X Startup Item"
  task :install do
    target_path = File.join("/","Library","StartupItems")

    # We cannot install this twice
    if File.exists?(File.join(target_path,"PostOffice"))
      puts "PostOffice Startup Item is already installed."
      exit
    end
    
    # We need /usr/bin/post_officed for this startup item to function
    unless File.exists?(File.join("/","usr","bin","post_officed"))
      puts "Error: missing /usr/bin/post_officed. Have you gem install post_office?"
      exit
    end

    puts "Installing Post Office Mac OS X Startup Item..."
    
    # Make sure /Library/StartupItems exists
    FileUtils.mkdir_p(target_path)
    
    source = File.join(File.dirname(__FILE__), "startup_item", "PostOffice")
    destination = File.join(target_path, "PostOffice")
    
    FileUtils.cp_r(source, destination)

    puts "Successfully installed Startup Item!"
  end

  desc "Removes Post Office Mac OS X Startup Item"
  task :remove do
    target_path = File.join("/","Library","StartupItems")

    unless File.exists?(File.join(target_path,"PostOffice"))
      puts "PostOffice Startup Item not installed."
      exit
    end

    puts "removing Post Office Mac OS X Startup Item..."
    FileUtils.rm_rf(File.join(target_path, "PostOffice"))
    puts "Successfully removed Startup Item!"
  end
end
  