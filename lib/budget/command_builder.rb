module Budget

  class CommandBuilder

    attr_reader :name, :desc, :subs, :op, :arity, :block

    def initialize(name, desc = nil)
      @name, @desc = name, desc
      @subs = {}
      @arity = 0
    end

    def command(name, desc = nil, abbr = nil, &block)
      @subs[name] = CommandBuilder.new name, desc
      @subs[abbr] = @subs[name] if abbr
      yield @subs[name] if block_given?
    end

    # short-hand for commands which take no options
    def action(name, desc = nil, abbr = nil, &block)
      command name, desc, abbr do |cmd|
        cmd.exec &block
      end
    end

    def opts(pargs = nil, oargs = nil, &block)
      @arity = pargs ? pargs.length : 0

      usage = "Usage: #{@name}"
      usage += " "+pargs.map{|pa| "<#{pa}>"}.join(' ') if pargs
      usage += " "+oargs.map{|oa| "[#{oa}]"}.join(' ') if oargs

      @op = OptionParser.new
      @op.banner = usage

      @op.on '-h', 'Show this help message' do
        puts op
        raise CommandExit
      end

      # allow block to define additional options
      yield @op if block_given?
    end

    def exec(&block)
      @block = block
    end

  end

end