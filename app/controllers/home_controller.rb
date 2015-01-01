class HomeController < ActionController::Base
  layout "application"

  require 'timeout'

  def index
  end

  def main_game
      @game_started = true
      @random_song = Music.random_song()
      if cookies.signed[:answering]
          score = Score.where(:uuid => cookies.signed[:id], :username => cookies.signed[:username])
          if !score.empty?
              score[0].wrong += 1
              score[0].save()
          end
      end
      cookies.signed[:answering] = true
  end

  def music_station
    @random_song = Music.random_song()
  end

  def alias
    username = params[:username]
    if !username.nil? && username != ""
      cookies.signed[:username] = username
    else
      cookies.signed[:username] = "Anonymous"
    end

    score_object = Score.where(:username => cookies.signed[:username]).first

    if !score_object.nil? and (cookies.signed[:username] != "Anonymous")
      cookies.signed[:id] = score_object.uuid
    else
      cookies.signed[:id] = SecureRandom.uuid
    end

    score = Score.where(:uuid => cookies.signed[:id], :username => cookies.signed[:username])
    if score.empty?
      score = Score.new
      score.username = cookies.signed[:username]
      score.uuid = cookies.signed[:id]
      score.correct = 0
      score.wrong = 0
      score.save()
    end

    redirect_to "/" and return
  end

  def ajax_autocomplete
    current_search = params[:search]

    anime_results = []
    if !current_search.nil?
        if Anime.where(:name => current_search).empty?
          anime_results = Sunspot.search(Anime) do
                               fulltext current_search
                           end
          anime_results = anime_results.results[0..5].sort_by{|ele| ele.ranking}.map{|ele| ele.name }

          if anime_results.length < 0
            search_characters = self.name.chars.to_a
            search_characters.delete("")

            anime_results = Sunspot.search(Anime) do
                                fulltext search_characters.join("")
            end
            anime_results = anime_results.results[0..5].sort_by{|ele| ele.ranking}.map{|ele| ele.name }
          end
        else
          anime_results = Anime.where(:name => current_search).map{|ele| ele.name }
        end
    end

    oped_map = {}

    for anime in anime_results
      oped_map[CGI.escapeHTML(anime)] = Oped.where(:anime_key => anime).map{|ele| ((ele.name + " by " + ele.artist) + (!Music.where(:oped_id => ele.id).first.nil? ? " (ALREADY ADDED)" : ""))}
    end

    puts oped_map

    if anime_results[0..5].length > 0
      render :json => {
        "anime" => anime_results[0..5].map{|ele| CGI.escapeHTML(ele)},
        "opeds" => oped_map
      }
    else
      render :json => {
        "anime" => []
      }
    end
  end

  def add_op_entry
    title = params[:title]
    url = params[:music_url]
    oped = params[:oped]

    target_anime = Anime.where(:name => title).first
    target_oped = Oped.where(:name => (oped.split("by")[0].strip!), :artist => (oped.split("by")[1].strip!)).first

    if target_anime and target_oped
      if Music.where(:oped_id => target_oped.id).empty?
        target_anime.delay.save_new_entry(target_oped, url)
      end

      redirect_to "/admin/add_page"
    else
      render :text => "RAWR"
    end
  end

  def add_op_entry_new
    url = params[:music_url]
    mp3_link = ""

    while mp3_link == ""
      Timeout::timeout(5000) {
        mp3_link = `casperjs convert_youtube_to_mp3.js --url="#{url}"`
      }
    end

    music_entry = Music.new
    music_entry.music = open(mp3_link)
    music_entry.save()

    puts mp3_link

    render :text => "RAWR"
  end

  def test_url

  end

  def submit_answer
    song_id = params[:song_id]
    answer = params[:answer]

    if cookies.signed[:last_scored].nil? or Float((Time.now - cookies.signed[:last_scored])) > 3
      if song_id and answer
          target_music = Music.find(song_id)
          if !target_music.nil? and target_music.anime.name == answer
              score = Score.where(:uuid => cookies.signed[:id], :username => cookies.signed[:username])
              if !score.empty?
                score[0].correct += 1
                score[0].save()
              end
              cookies.signed[:last_scored] = Time.now
              cookies.signed[:answering] = false
              render :json => {
                "result" => "Correct",
                "song_name" => target_music.oped.name + " by " + target_music.oped.artist
              } and return
          end
      end
    end

    render :text => "Wrong" and return
  end

  def retrieve_answer
    song_id = params[:song_id]

    if song_id
      target_music = Music.find(song_id)
      if !target_music.nil?
        score = Score.where(:uuid => cookies.signed[:id], :username => cookies.signed[:username])
        if !score.empty?
            score[0].wrong += 1
            score[0].save()
        end
        cookies.signed[:answering] = false
        render :json => {
          "anime" => target_music.anime.name,
          "song_name" => target_music.oped.name + " by " + target_music.oped.artist
        } and return
      end
    end
    render :text => "Undefined" and return
  end
end
