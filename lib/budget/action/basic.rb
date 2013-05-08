module Budget

  class Manager

    @cmd.action :shell, 'Start an interactive command session', :s do
      print "> "
      while cmd = $stdin.gets
        begin
          dispatch Shellwords::split(cmd)
        rescue CommandExit
        rescue SystemExit, Interrupt
          # allow interrupts and ctrl-C to propagate
          raise
        rescue Exception => e
          report_error e
        end
        print "> "
      end
      print "\n"
    end

  end

end