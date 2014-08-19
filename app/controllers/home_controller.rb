class HomeController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout "application"

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
    render :json => anime_results[0..5]
  end

  def add_op_entry
    title = params[:title]
    music_file = params[:music_file]
    artist = params[:artist]
    image_file = params[:image_file]
    name = params[:song_name]

    target_anime = Anime.where(:name => title)[0]
    
    if target_anime
      music_entry = Music.new
      music_entry.music_file = music_file
      music_entry.anime = title
      music_entry.name = name
      music_entry.artist = artist
      music_entry.image = image_file
      music_entry.save()
      redirect_to "/admin/add_page"
    else
      render :text => "RAWR"
    end
  end

  def submit_answer
    song_id = params[:song_id]
    answer = params[:answer]

    if cookies.signed[:last_scored].nil? or Float((Time.now - cookies.signed[:last_scored])) > 3
      if song_id and answer
          target_music = Music.find(song_id)
          if !target_music.nil? and target_music.anime == answer
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
