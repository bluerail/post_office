class StartupItem
  def self.install
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
    
    source = File.join(File.dirname(__FILE__), "..", "startup_item", "PostOffice")
    destination = File.join(target_path, "PostOffice")
    
    FileUtils.cp_r(source, destination)

    puts "Successfully installed Startup Item!"
  end

  def self.remove
    target_path = File.join("/","Library","StartupItems")

    unless File.exists?(File.join(target_path,"PostOffice"))
      puts "PostOffice Startup Item not installed."
      exit
    end

    puts "removing Post Office Mac OS X Startup Item..."
    FileUtils.rm_rf(File.join(target_path, "PostOffice"))

    unless File.exists?(File.join(target_path,"PostOffice"))
      puts "Successfully removed Startup Item!"
    else
      puts "Unable to remove Startup Item: hae you used sudo?"
    end
  end
end
