module Envandle
  class GemspecCache
    @@mutex = Mutex.new

    def initialize(path)
      @path = path
      FileUtils.mkdir_p @path
    end

    attr_reader :path

    def with_file
      path = File.join(@path, "list")
      @@mutex.synchronize do
        File.open(path, File::RDWR | File::CREAT) do |f|
          f.flock File::LOCK_EX
          yield f
        end
      end
    end

    def append(url, dir)
      with_file do |f|
        data = YAML.load(f.read) || {}
        data[url] = dir
        f.rewind
        f.write data.to_yaml
        f.flush
        f.truncate f.pos
      end
    end

    def load
      with_file do |f|
        YAML.load(f.read) || {}
      end
    end

    def find(url)
      if dir = load[url]
        File.join(@path, dir)
      end
    end

    def reserve
      Reserved.new(@path)
    end

    class Reserved
      def initialize(cache_path)
        @cache_path = cache_path
        @path = Envandle.tmpdir(nil, cache_path)
      end

      attr_reader :path

      def url=(v)
        @url = v
      end

      def save
        GemspecCache.new(@cache_path).append @url, @path[(@cache_path.size+1)..-1]
      end
    end
  end
end
