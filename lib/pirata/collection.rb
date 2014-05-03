module Pirata
  class Collection
    
    def initialize(torrent_array = [])
      @torrents = torrent_array
    end

    def add(torrent, i = nil)
      i ? @torrents.insert(torrent, i) : @torrents << torrent
    end
    
    def delete(torrent)
      @torrents.delete(torrent)
    end
    
    def size
      @torrents.length
    end
    
  end
end