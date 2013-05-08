module Budget

  module Action

    def action_summary
      action_account_summary
    end

    def action_shell
      print "> "
      begin
        while cmd = $stdin.gets
          begin
            dispatch cmd.split(" ")
          rescue SystemExit, Interrupt
            raise
          rescue Exception => e
            puts "ERROR: #{e.inspect}\n#{e.backtrace.join "\n"}"
          end
          print "> "
        end
      rescue Exception; end
      print "\n"
    end
    alias_method :action_s, :action_shell

  end

end