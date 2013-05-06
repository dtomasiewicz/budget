require 'fileutils'

module Budget

  class Manager

    def initialize(cfg)
      @config = cfg
    end

    def summary
    end

    def init
      FileUtils.cp File.join(GEM_DIR, 'budget_base.db'), @cfg[:dbfile]
    end

    private

    def db
      @db ||= SQLite3::Database.new @config[:dbfile]
    end

  end

end