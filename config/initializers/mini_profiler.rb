if defined? Rack::MiniProfiler
  # set MemoryStore
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
end

