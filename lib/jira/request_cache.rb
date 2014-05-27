module JIRA

  class RequestCache

    def initialize(time_to_live)
      @time_to_live = time_to_live
    end

    def load(path)
      key = cache_key(path)
      cache_object = cache(path)
      response = verify cache_object[key]

      if response == :expired
        cache_object.delete(key)
        cache_file(path, 'w+').write(Marshal.dump(cache_object))
        nil
      else
        response
      end
    end

    def save(path, response)
      now = Time.now.to_i

      new_cache = cache(path)
      new_cache[cache_key(path)] = {
        'data' => response,
        'timestamp' => now
      }

      cache_file(path, 'w+').write(Marshal.dump(new_cache))
    end


    private

    def verify(cache_value)
      now = Time.now.to_i
      #binding.pry
      if cache_value == nil
        return nil
      elsif cache_value['timestamp'] < (now - @time_to_live)
        :expired
      else
        cache_value['data']
      end
    end

    def cache(path)
      #binding.pry
      if File.exists? 'cache/' + path
        Marshal.restore(cache_file(path, 'r+').read())
      else
        {}
      end
    end

    def cache_key(path)
      return "key"
      #Marshal.dump(path)
    end

    def cache_file(path, mode)
      dir = cache_dir
      File.new(dir + '/' + path, mode)
    end

    def cache_dir
      dir = 'cache'
      
      unless Dir.exists? dir
        FileUtils.mkdir_p(dir)
      end
      
      dir
    end
  end

end