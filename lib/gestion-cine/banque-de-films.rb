module GestionCine

  # Classe qui va permettre de mettre en place la base
  # de donnees a partir d un fichier json envoye par
  # l utilisateur
  #
  class BanqueDeFilms

    # Initialise le depot.
    #
    # @param [String] depot - le nom du fichier avec la base de donnees
    # @param [Bool] detruire - option qui permet de supprimer le fichier s il existe
    #
    def self.init( depot, detruire )
      if File.exist? depot
        if detruire
          FileUtils.rm_f depot
          fail "Le fichier '#{depot}' existe.
          Si vous voulez le detruire, utilisez 'init --detruire'."
        end
      end
      FileUtils.touch depot
    end

    # Charge la base de donnee a partir du depot.
    #
    # @param [String] depot - le nom du fichier avec la base de donnees
    #
    def self.charger( depot )
      fail "Le fichier '#{depot}' n'existe pas!" unless File.exist? depot
      @depot = depot
      file = File.read(depot)
      data_hash = JSON.parse(file)
      @les_films = data_hash. map { |e| GestionCine::FilmJson.creer_film(e) }
    end



    # Sauvegarde les films dans le depot initialise au prealable.
    #
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
    #
    # @param [String] imdbid - l imdbid du film a creer.
    # @param [Array] jours - jours lesquels le film sera diffuse.
    # @param [Fixnum] salles - nombre de salles dans lequel est diffuse le film.
    #
    def self.ajouter( imdbid, jours, salles )
      @les_films << Film.new( imdbid, jours, salles )
    end

    # Supprime un cours dans le depot
    #
    # @param [Film] film - objet de la classe Film a supprimer
    #
    def self.supprimer( film )
      @les_films.delete film
    end

    # Modifie un film dans le depot en indiquand l imdbid,
    # le nombre de salles, et les jours de diffusions
    #
    # @param [String] imdbid - l imdbid du film a creer.
    # @param [Array] jours - jours lesquels le film sera diffuse.
    # @param [Fixnum] salles - nombre de salles dans lequel est diffuse le film.
    #
    def self.modifier( imdbid, salles, jours )
      @les_films.each do |f|
        if f.imdbid == imdbid && !jours.nil?
          f.jours << jours
          f.jours = f.jours.flatten(1)
        end
        if f.imdbid == imdbid && !salles.nil?
          f.salles = Integer(salles) + f.salles
        end
      end
    end

    def self.les_films_motif( motif )
      @les_films. select { |f| /#{motif}/i =~ f.titre }
    end

    # Retourne la liste des films et ceux du mois si indique par
    # l utilisateur lors de l appel
    #
    # @param [String] mois - mois pendant lequel les films ont ete publies
    #
    def self.les_films( mois=nil )
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

    # Retourne un objet de la classe Film ayant l imdbid
    # indique par l utilisateur
    # @param [String] imdbid - l imdbid du film a chercher.
    #
    def self.le_film( imdbid )
      film = @les_films. select { |f| /^#{imdbid}$/ =~ f.imdbid }

      fail "Plusieurs films avec imdbid #{imdbid.inspect}" if film.size > 1

      film.first
    end

    # Verifie si le film indique contient le jour a ajouter
    #
    # @param [String] imdbid - l imdbid du film auquel on veut ajouter le jour.
    # @param [String] j - jour a ajouter par l utilisateur.
    #
    def self.jour_present( j, imdbid )
      @les_films.each do |f|
        if f.jours.include? j
          if f.imdbid == imdbid
            return true
          end
        end
      end
      false
    end

  end

end
