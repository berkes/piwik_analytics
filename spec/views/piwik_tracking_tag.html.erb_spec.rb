require "erb"

describe "views/piwik_tracking_tag.html.erb" do
  before(:each) do
    filename = File.join(File.dirname(__FILE__), '..', '..', 'app', 'views', 'piwik_analytics', 'piwik_tracking_tag.html.erb')
    @template = ERB.new(File.read(filename))
  end

  it "should render url" do
    url = "example.com"
    id_site = nil
    id_user = nil
    @template.result(binding).should =~ /http:\/\/example.com/
  end

  it "should render id_site" do
    url = nil
    id_site = 4
    id_user = nil
    @template.result(binding).should =~ /"piwik\.php", 4/
  end

  it "should render id_user" do
    url = nil
    id_site = nil
    id_user = 1337
    @template.result(binding).should =~ /piwikTracker\.setUserId\('1337'\)/
  end
end
