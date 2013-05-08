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

    # Executes a command defined by the given arguments.
    def dispatch(args)
      @action = nil
      @args = args
      redispatch(shell: 'Start an interactive command session',
                 account: 'Manage accounts',
                 income: 'Manage incomes')
    end

    private

    # Can be called by actions to recursively dispatch to sub-actions. The
    # sub-action to dispatch is based on the first argument; if the first
    # argument is not a valid sub-action, a list of valid actions will be 
    # shown as specified by the _usage_ hash. If there are no arguments, the 
    # 'summary' sub-action will be dispatched.
    def redispatch(usage)
      prefix = "#{@action || 'action'}_"
      if @args[0]
        a = :"#{prefix}#{@args[0]}"
        if respond_to?(a, true)
          @args.shift
        else
          for_cmd = @action ? " for '#{command}'" : ''
          fmt = "  %-15s%-61s"
          $stderr.puts "'#{@args[0]}' is not recognized. Valid actions#{for_cmd} include:"
          usage.each_pair do |action, desc|
            $stderr.puts fmt % [action, desc]
          end
          exit
        end
      else
        a = :"#{prefix}summary"
      end
      send @action = a
      @args = @action = nil
    end

    def report_error(error)
      msg = "ERROR: #{error.inspect}"
      msg += "\n#{error.backtrace.join "\n"}" if @verbose
      $stderr.puts msg
    end

    def opts(pargs = nil, oargs = nil, &block)
      usage = "Usage: #{command}"
      usage += " "+pargs.map{|pa| "<#{pa}>"}.join(' ') if pargs
      usage += " "+oargs.map{|oa| "[#{oa}]"}.join(' ') if oargs

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
      print "> "
      begin
        while cmd = $stdin.gets
          begin
            @shell = true
            dispatch Shellwords::split(cmd)
            @shell = false
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
    end
    def action_s; switch :action_shell; end

    include Action

  end

  class CommandExit < SystemExit; end

end