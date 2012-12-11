require "piwik_analytics/helpers"
require "piwik_analytics/piwik_tracker"

class HelpersDouble
  include PiwikAnalytics::Helpers
end

describe PiwikAnalytics::Helpers do
  before(:each) do
    @double = HelpersDouble.new
  end

  describe "#piwik_tracking_tag" do
    before(:each) do
      @config = mock("Configuration").as_null_object
    end

    context "disabled" do
      it 'should return nil if disabled' do
        @config.stub(:disabled?).and_return true
        PiwikAnalytics.stub(:configuration).and_return @config
        @double.piwik_tracking_tag.should be_nil
      end
    end

    context "enabled" do
      before(:each) do
        @config.stub(:disabled?).and_return false
      end

      it 'should render' do
        PiwikAnalytics.stub(:configuration).and_return @config
        @double.should_receive(:render)
        @double.piwik_tracking_tag
      end

      it 'should use file piwik_tracking_tag_async when async' do
        @config.stub(:use_async?).and_return true
        PiwikAnalytics.stub(:configuration).and_return @config

        @double.should_receive(:render).with(hash_including(:file => 'piwik_analytics/piwik_tracking_tag_async'))
        @double.piwik_tracking_tag
      end

      it 'should use file piwik_tracking_tag when not async' do
        @config.stub(:use_async?).and_return false
        PiwikAnalytics.stub(:configuration).and_return @config

        @double.should_receive(:render).with(hash_including(:file => 'piwik_analytics/piwik_tracking_tag'))
        @double.piwik_tracking_tag
      end
    end
  end

  context 'tracking api' do
    it 'should have a piwik_tracker method' do
      @double.should respond_to(:piwik_tracker)
    end
    it 'should return a PiwikTracker' do
      PiwikAnalytics.stub(:piwik_tracker).and_return(PiwikAnalytics::PiwikTracker.new)
      @double.piwik_tracker.should be_an_instance_of(PiwikAnalytics::PiwikTracker)
    end
  end
end
