require 'yaml'

module CodebreakerRackApp
  class SessionHelper
    @@sessions_path = File.expand_path('../../../sessions.yml', __FILE__)

    def next_id
      return 1 unless all
      all.last.session_id + 1
    end

    def session(session_id)
      all.select { |el| el.session_id == session_id }.first
    end

    def save(session)
      sessions = all || []
      sessions.delete_if { |el| el.session_id == session.session_id }
      sessions.push session
      File.write(@@sessions_path, YAML.dump(sessions))
    end

    def all
      YAML.load(File.read(@@sessions_path), permitted_classes: [Session, Codebreaker::Game, CodebreakerRackApp::Score, Time]) if File.readable? @@sessions_path
    end
  end
end
