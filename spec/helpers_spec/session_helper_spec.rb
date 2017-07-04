require './spec/spec_helper'

module CodebreakerRackApp
  class SessionHelperSpec
    RSpec.describe SessionHelper do
      let(:first_session) { CodebreakerRackApp::Session.new(1, 'first') }
      let(:third_session) { CodebreakerRackApp::Session.new(3, 'third') }
      let(:sessions) do
        [first_session,
         CodebreakerRackApp::Session.new(2, 'second'),
         third_session]
      end
      let(:fourth_session) { CodebreakerRackApp::Session.new(4, 'fourth') }

      describe '#next_id' do
        it 'return "1" from initial' do
          expect(subject.next_id).to eq(1)
        end

        it 'return "111" when session_id = 110' do
          SessionHelper.class_variable_set :@@session_id, 110
          expect(subject.next_id).to eq(111)
        end
      end

      describe '#session' do
        before(:each) do
          allow(subject).to receive(:all).and_return(sessions)
        end
        it 'return third session when session_id = 3' do
          expect(subject.session(3).game).to eq(third_session.game)
        end
        it 'return first session when session_id = 1' do
          expect(subject.session(1).game).to eq(first_session.game)
        end
        it 'return nil when session_id = 4' do
          expect(subject.session(4)).to be_nil
        end
      end

      describe '#save' do
        context 'all empty' do
          before(:each) do
            allow(subject).to receive(:all).and_return(nil)
          end

          it 'call File.write with given session' do
            expect(YAML).to receive(:dump).with([first_session])
            subject.save(first_session)
          end

        end
        context 'all has elements' do
          before(:each) do
            allow(subject).to receive(:all).and_return(sessions)
          end

          it 'call File.write array that contain pushed session' do
            expect(YAML).to receive(:dump).with(sessions.push fourth_session)
            subject.save(fourth_session)
          end

          it 'should update by given item' do
            third_session.game = 'third_updated'
            sessions.delete_if { |el| el.session_id == third_session.session_id }
            expect(YAML).to receive(:dump).with(sessions.push third_session)
            subject.save(third_session)
          end
        end
      end
    end
  end
end