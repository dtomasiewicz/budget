require 'fileutils'
require 'shellwords'
require 'sequel'

Sequel::Model.raise_on_save_failure = true
Sequel::Model.raise_on_typecast_failure = true
Sequel::Model.plugin :dataset_associations

require 'budget/action'
require 'budget/currency'
require 'budget/model'

Sequel.extension :inflector

module Budget

  class Manager

    def initialize
      @verbose = false
      @shell = false
    end

    def dispatch(args = nil)
      if args
        @action = nil
        @args = args
      end
      prefix = "#{@action || 'action'}_"
      if @args[0] && respond_to?(@action = :"#{prefix}#{@args[0]}", true)
        @args.shift
      else
        @action = :"#{prefix}summary"
      end
      send @action
      @args = @action = nil
    end

    private

    def redispatch
      puts "redispatching #{@args}"
    end

    def report_error(error)
      msg = "ERROR: #{error.inspect}"
      msg += "\n#{error.backtrace.join "\n"}" if @verbose
      $stderr.puts msg
    end

    def opts(pargs = nil, opargs = nil, &block)
      usage = "Usage: #{command}"
      usage += " "+pargs.join(' ') if pargs
      usage += " "+opargs.map{|oa| "[#{oa}]"}.join(' ') if opargs

      op = OptionParser.new
      op.banner = usage
      op.on '-h', 'Show this help message' do
        puts op
        exit
      end
      op.on '--verbose', "Show full stack trace with error messages" do |v|
        @verbose = true
      end

      # allow block to define additional options
      yield op if block_given?

      args = op.parse @args
      # ensure there are enough positional arguments after parsing; otherwise show usage
      if pargs && args.length < pargs.length
        puts op
        exit
      end
      args
    end

    def exit
      if @shell
        raise CommandExit
      else
        super
      end
    end

    def command
      @action.to_s[7..-1].gsub '_', ' '
    end

    def switch(action)
      send @action = action
    end

    def action_summary
      action_account_summary
    end

    def action_shell
      @shell = true
      print "> "
      begin
        while cmd = $stdin.gets
          begin
            dispatch Shellwords::split(cmd)
          rescue CommandExit
          rescue SystemExit, Interrupt
            raise
          rescue Exception => e
            report_error e
          end
          print "> "
          @verbose = false
        end
      rescue Exception; end
      print "\n"
      @shell = false
    end
    def action_s; switch :action_shell; end

    include Action

  end

  class CommandExit < SystemExit; end

end