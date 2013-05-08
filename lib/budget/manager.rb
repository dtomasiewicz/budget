require 'fileutils'
require 'shellwords'
require 'sequel'

Sequel::Model.raise_on_save_failure = true
Sequel::Model.raise_on_typecast_failure = true
Sequel::Model.plugin :dataset_associations

require 'budget/command_builder'
require 'budget/currency'
require 'budget/model'

Sequel.extension :inflector

module Budget

  class Manager

    @cmd = CommandBuilder.new 'budget'

    def self.dispatch(args)
      cb = @cmd
      cmd = []
      while args[0] && (sub = cb.subs[args[0].to_sym])
        cmd << (cb = sub)
        args.shift
      end

      if !cb.block
        if args.length == 0 && cb.subs[:summary]
          cmd << (cb = cb.subs[:summary])
        else
          for_cmd = cmd.length > 0 ? " for '#{cmd.map(&:name).join ' '}'" : ''
          fmt = "  %-15s%-61s"
          $stderr.puts "'#{args[0]}' is not recognized. Valid actions#{for_cmd} include:"
          cb.subs.values.uniq.each do |cb|
            $stderr.puts fmt % [cb.name, cb.desc]
          end
          return
        end
      end

      begin
        args = cb.op.parse args if cb.op

        # ensure there are enough positional arguments after parsing; otherwise show usage
        if args.length < cb.arity
          puts cb.op
        else
          instance_eval do
            cb.block.call *args
          end
        end
      rescue CommandExit; end
    end

    private

    def self.report_error(error)
      msg = "ERROR: #{error.inspect}"
      msg += "\n#{error.backtrace.join "\n"}"
      $stderr.puts msg
    end

  end

  class CommandExit < SystemExit; end

end

require 'budget/action'