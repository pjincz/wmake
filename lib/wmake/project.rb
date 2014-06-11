module WMake
  PROJECTS = {}
  class Project
    def initialize name, type = :exec, &block
      die "Project named \"#{name}\" already exists!" if PROJECTS[name]
      die "Unknown project type: #{type}" unless [:exec].include? type
      die "Project without config!" unless block
      PROJECTS[name] = self
      @name = name
      @type = type
      @block = block
      @wmake = FRONT.loading_stack.last
      @files = []
      @depends = []
      @exclude_by_default = false
    end
    attr_reader :name
    attr_reader :type
    attr_reader :files
    attr_reader :depends
    attr_reader :exclude_by_default
    def configure
      instance_eval &@block
    end
    def add *args
      @files += args
    end
    def pre_check_files
      [@wmake]
    end
    def products
      PLATFORM.products self
    end
    def dir
      File.dirname @wmake
    end
  end
end