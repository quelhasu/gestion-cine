module GestionCine

  class BanqueDeFilms


    def self.init( depot, detruire )
      if File.exist? depot
        if detruire
          FileUtils.rm_f depot
          fail "Le fichier '#{depot}' existe deja.
          Si vous voulez le detruire, utilisez 'init --detruire'."
        end
      end
      FileUtils.touch depot
    end

    def self.charger( depot )
      fail "Le fichier '#{depot}' n'existe pas!" unless File.exist? depot

      @depot = depot

      file = File.read(depot)
      data_hash = JSON.parse(file)
      @les_films = data_hash
      . map { |e| GestionCine::FilmJson.creer_film(e) }
    end



    # Sauvegarde les films dans le depot initialise au prealable.
    def self.sauver
      FileUtils.cp @depot, "#{@depot}.bak" # Copie de sauvegarde.

      collections = []
      @les_films.each do |f|
        collections << GestionCine::FilmJson.transformer( f )
      end

      File.open( @depot, "w" ) do |fich|
        fich.puts JSON.pretty_generate collections
      end
    end

    # Ajoute un film dans le depot
    def self.ajouter( imdbid, jours, salles )
      @les_films << Film.new( imdbid, jours, salles )
    end

    # Selectionne les films selon le mois si indique
    def self.les_films( mois = nil )
      if mois.nil?
        @les_films
      else
        case mois
        when "janvier"
          le_mois = "Jan"
        when "fevrier"
          le_mois = "Feb"
        when "mars"
          le_mois = "Mar"
        when "avril"
          le_mois = "Apr"
        when "mai"
          le_mois = "May"
        when "juin"
          le_mois = "Jun"
        when "juillet"
          le_mois = "Jul"
        when "aout"
          le_mois = "Aug"
        when "septembre"
          le_mois = "Sep"
        when "octobre"
          le_mois = "Oct"
        when "novembre"
          le_mois = "Nov"
        when "decembre"
          le_mois = "Dec"
        end
        @les_films
          .select { |e| e.sortie.match(/\b[a-zA-Z]+\b/).to_s == le_mois}
      end
    end

    def self.sort_films ( option = nil )
      if option.nil?
        @les_films .sort
      elsif option == "annee"
        @les_films .sort_by(&annee)
      elsif option == "top"
        @les_films .sort_by(&note)
      elsif option == "duree"
        @les_films .sort_by(&duree)
      end
    end
  end

end
