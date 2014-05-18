require 'test/unit'
require 'pirata'

class PirataTest < Test::Unit::TestCase
  
  # This file is getting kind of big/messy, test should be broken up
  # into modular and logical parts
  
  def test_basic_search
    s = Pirata::Search.new("skyrim")
    assert_equal(30, s.results.length)
    assert_equal(Pirata::Search, s.class)
    assert_equal(Pirata::Torrent, s.results.first.class)
  end
  
  def test_top
    assert_equal(100, Pirata::Search.top.length)
  end
  
  def test_top_category
    assert_equal(100, Pirata::Search.top(Pirata::Category::APPLICATIONS).length)
  end
  
  def test_recent
    assert_equal(30, Pirata::Search.recent.length)
  end
      
  def test_multicategory_search
    categories = [Pirata::Category::AUDIO, Pirata::Category::GAMES]
    s = Pirata::Search.new("zelda", Pirata::Sort::RELEVANCE, categories)
    assert_equal(30, s.results.length)
    assert_equal(Pirata::Torrent, s.results.first.class)
  end
  
  def test_multiple_subcategory_search
    categories = [Pirata::Category::AUDIO_MUSIC, Pirata::Category::GAMES_WII,
                  Pirata::Category::COMICS, Pirata::Category::VID_MOVIES]
    s = Pirata::Search.new("zelda", Pirata::Sort::RELEVANCE, categories)
    assert_equal(30, s.results.length)
    assert_equal(Pirata::Torrent, s.results.first.class)
  end
    
  def test_nondefault_sorting
    s = Pirata::Search.new("zelda", Pirata::Sort::DATE)
    assert_equal(s.results[0].date > s.results[1].date, true)
  end
    
  def test_multipage_search
    s = Pirata::Search.new("zelda")
    assert_equal(true, s.multipage?)
    assert_equal(true, s.pages > 0)
    assert_equal(30, s.search_page(2).length)
  end
    
  def test_torrent_object_variables
    torrent = Pirata::Search.new("zelda").results.first
    assert_equal(String, torrent.title.class)
    assert_equal(String, torrent.category.class)
    assert_not_nil(/http.*/.match(torrent.url))
    assert_equal(Fixnum, torrent.id.class)
    assert_not_nil(/magnet:\?.*/.match(torrent.magnet))
    assert_equal(Fixnum, torrent.seeders.class)
    assert_equal(Fixnum, torrent.leechers.class)
  end
      
  def test_find_torrent_by_id
    torrent = Pirata::Torrent.find_by_id(5241636)
    assert_equal("Ocarina of Time: Complete Collection - Zelda Reorchestrated", torrent.title)
    assert_equal(85, torrent.files)
    assert_equal("F4866D794FA7855A2FEC2FE45276B7F72510B960", torrent.hash)
    assert_equal(Time, torrent.date.class)
  end
  
end