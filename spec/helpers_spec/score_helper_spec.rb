require './spec/spec_helper'

module CodebreakerRackApp
  class ScoreHelperSpec
    RSpec.describe ScoreHelper do
      let(:session) do
        CodebreakerRackApp::Session.new(1,"Game")
      end
      let(:session_helper) { CodebreakerRackApp::SessionHelper.new }

      describe '#get_score' do
        before(:each) do
          subject.instance_variable_set(:@sessions_helper,session_helper)
        end
        it 'return 1000 when hints don\'t used and attempts <= 3' do
          allow(session_helper).to receive(:session).with(1).and_return(session)
          expect(subject.get_score(1)).to eq(1000)
        end
        it 'return 0 when 3 hints and 15 attempts is used' do
          session.instance_variable_set(:@hint_counter,3)
          session.instance_variable_set(:@attempts_counter,15)
          allow(session_helper).to receive(:session).with(1).and_return(session)
          expect(subject.get_score(1)).to eq(0)
        end
        it 'return 340 when 0 hints and 15 attempts is used' do
          session.instance_variable_set(:@hint_counter,0)
          session.instance_variable_set(:@attempts_counter,15)
          allow(session_helper).to receive(:session).with(1).and_return(session)
          expect(subject.get_score(1)).to eq(340)
        end
      end
    end
  end
end