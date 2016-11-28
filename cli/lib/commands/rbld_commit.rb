require 'getoptlong'

module Rebuild::CLI
  class RbldCommitCommand < Command
    def initialize
      @usage = "commit [OPTIONS] [ENVIRONMENT[:TAG]]"
      @description = "Commit environment modifications"
      @options = [["-t TAG,--tag TAG", "New tag to be created"]]
    end

    def parse_opts(parameters)
      replace_argv( parameters ) do
        opts = GetoptLong.new([ '--tag', '-t', GetoptLong::REQUIRED_ARGUMENT ])
        tag = nil
        opts.each do |opt, arg|
          case opt
            when '--tag'
              tag = arg
          end
        end

        raise "New tag not specified" unless tag
        Environment.validate_component( 'new tag', tag )
        return tag, ARGV
      end
    end

    def run(parameters)
      new_tag, parameters = parse_opts( parameters )

      Rebuild::EnvManager.new do |mgr|
        env = Environment.new( parameters[0] )
        rbld_log.info("Going to commit #{env}")
        mgr.commit!(env.full, env.name, env.tag, new_tag)
      end
    end
  end
end
