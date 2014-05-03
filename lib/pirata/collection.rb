module Pirata
  class Collection
    
    def initialize(torrent_array = [])
      @torrents = torrent_array
    end

    def add(torrent, i = nil)
      i ? @torrents.insert(torrent, i) : @torrents << torrent
    end
    
    def [](i)
      @torrents[i]
    end
    
    def delete(torrent)
      @torrents.delete(torrent)
    end
    
    def size
      @torrents.length
    end
    
    def take(n)
      @torrents.take(n)
    end
    
  end
end