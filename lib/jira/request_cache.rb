module JIRA

  class RequestCache

    def initialize(time_to_live)
      @time_to_live = time_to_live
    end

    def load(uri)
      key = cache_key(uri)
      cache_object = cache(uri)
      response = verify cache_object[key]

      if response == :expired
        cache_object.delete(key)
        cache_file(uri, 'w+').write(Marshal.dump(cache_object))
        nil
      else
        response
      end
    end

    def save(uri, response)
      now = Time.now.to_i

      new_cache = cache(uri)
      new_cache[cache_key(uri)] = {
        'data' => response,
        'timestamp' => now
      }

      cache_file(uri, 'w+').write(Marshal.dump(new_cache))
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

    def cache(uri)
      if File.exists? cache_path(uri)
        Marshal.restore(cache_file(uri, 'r+').read())
      else
        {}
      end
    end

    def cache_key(uri)
      return "key"
      #Marshal.dump(uri)
    end

    def cache_file(uri, mode)
      path = cache_path(uri)
      File.new(path, mode)
    end

    def cache_path(uri)
      dir = 'cache'
      
      unless Dir.exists? dir
        FileUtils.mkdir_p(dir)
      end
      
      dir + '/' + uri.gsub('/', '_')
    end
  end

end