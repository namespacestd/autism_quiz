class HomeController < ActionController::Base
  layout "application"

  require 'timeout'

  def index
      @game_started = true
      @random_song = Music.random_song()
      if cookies.signed[:answering]
          score = Score.where(:uuid => cookies.signed[:id], :username => cookies.signed[:username])
          if !score.empty? and score[0].score != 0
              score[0].score -= 1
              score[0].save()
          end
      end
      cookies.signed[:answering] = true
  end

  def alias
    username = params[:username]
    if !username.nil? && username != ""
      cookies.signed[:username] = username
    else
      cookies.signed[:username] = "Anonymous"
    end

    cookies.signed[:id] = SecureRandom.uuid
    score = Score.where(:uuid => cookies.signed[:id], :username => cookies.signed[:username])
    if !score.empty?
      score = Score.new
      score.username = cookies.signed[:username]
      score.uuid = cookies.signed[:id]
      score.score = 0
      score.save()
    end

    redirect_to "/" and return
  end

  def ajax_autocomplete
    current_search = params[:search]

    anime_results = []
    if !current_search.nil?
        anime_results = Sunspot.search(Anime) do
                             fulltext current_search
                             order_by(:ranking, :asc)
                         end
        anime_results = anime_results.results.map{|ele| ele.name}
        puts anime_results
    end

    oped_map = {}

    for anime in anime_results[0..5]
      oped_map[CGI.escapeHTML(anime)] = Oped.where(:anime_key => anime).map{|ele| (ele.name + " by " + ele.artist)}
    end

    puts oped_map

    render :json => {
      "anime" => anime_results[0..5].map{|ele| CGI.escapeHTML(ele)},
      "opeds" => oped_map
    }
  end

  def add_op_entry
    title = params[:title]
    url = params[:music_url]
    oped = params[:oped]

    target_anime = Anime.where(:name => title).first
    target_oped = Oped.where(:name => (oped.split("by")[0].strip!), :artist => (oped.split("by")[1].strip!)).first

    if target_anime and target_oped
      target_anime.delay.save_new_entry(target_oped, url)

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
                score[0].score += 1
                score[0].save()
              end
              cookies.signed[:last_scored] = Time.now
              cookies.signed[:answering] = false
              render :text => "Correct" and return
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
        if !score.empty? and score[0].score != 0
            score[0].score -= 1
            score[0].save()
        end
        cookies.signed[:answering] = false
        render :text => target_music.anime and return
      end
    end
    render :text => "Undefined" and return
  end
end
