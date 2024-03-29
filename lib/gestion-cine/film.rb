module GestionCine

  # Class permettant de creer un film
  # Tous les champs sont immuables.
  #
  class Film
    include Comparable
    attr_reader :imdbid, :jours, :salles, :titre, :annee, :note,
                :genre, :real, :synopsis, :sortie, :duree

    # Initialiser un film a partir des parametres suivants.
    #
    # @param [String] imdbid - l imdbid du film a creer.
    # @param [Array] jours - jours lesquels le film sera diffuse.
    # @param [Fixnum] salles - nombre de salles dans lequel est diffuse le film.
    #
    def initialize( imdbid, nbsalles=0, jours=nil )
      film = OMDB.id(imdbid)
      @imdbid = imdbid
      @jours = jours
      @salles = nbsalles
      @titre = film.title
      @annee = film.year
      @note = film.imdb_rating
      @genre = film.genre
      @real = film.director
      @scenariste = film.writer
      @synopsis = film.plot
      @sortie = film.released
      @duree = film.runtime
    end

    # Formate un cours selon les indications specifiees par le_format:
    #
    #  -  %I:   imdbid
    #  -  %J:	  jours
    #  -  %T:	  titre
    #  -  %S:	  salles
    #  -  %A:	  annee
    #  -  %N:	  note
    #  -  %G:	  genre
    #  -  %R:	  real
    #  -  %P:	synopsis
    #  -  %O:	sortie
    #  -  %M:	duree
    #
    # Des indications de largeur, justification, etc. peuvent aussi etre
    # specifiees, par exemple, %-10T, %-.10T, etc.
    #
    def to_s( le_format = nil )
      sep_jours = FilmJson::SEPARATEUR_JOURS
      if le_format.nil?
        return format("\"%s\" (real. %s) - {%s} (%s)",
                        titre,
                        real,
                        jours.join(sep_jours),
                        salles)
      end

      form = le_format
      res = []
      chaque_car = le_format.split(" ")

      chaque_car.each do |f|
        case f
        when /%(-)?\d*I/
          form = form.gsub('I','s')
          res << "#{imdbid}"
        when /%(-)?\d*J/
          form = form.gsub('J','s')
          n_jours = jours.join(sep_jours)
          res << "#{n_jours}"
        when /%(-)?\d*T/
          form = form.gsub('T','s')
          res << "#{titre}"
        when /%(-)?\d*S/
          form = form.gsub('S','s')
          res << "#{salles}"
        when /%(-)?\d*A/
          form = form.gsub('A','s')
          res << "#{annee}"
        when /%(-)?\d*N/
          form = form.gsub('N','s')
          res << "#{note}"
        when /%(-)?\d*G/
          form = form.gsub('G','s')
          res << "#{genre}"
        when /%(-)?\d*R/
          form = form.gsub('R','s')
          res << "#{real}"
        when /%(-)?\d*P/
          form = form.gsub('P','s')
          res << "#{synopsis}"
        when /%(-)?\d*O/
          form = form.gsub('O','s')
          res << "#{sortie}"
        when /%(-)?\d*M/
          form = form.gsub('M','s')
          res << "#{duree}"
        when /"/
          form = form.gsub('"','\"')
        end
      end
      return form % res
      fail "Cas non traite: to_s( #{le_format}, #{separateur_prealables} )"
    end

    # Ordonner les films selons leur titre
    #
    # @param [Film] autre - Objet de la classe film.
    #
    def <=>( autre )
      titre <=> autre.titre
    end

    # Permet de modifier les jours de diffusions d un objet Film.
    #
    # @param [Array] array - Les jours a ajouter aux films.
    #
    def jours=( array )
      @jours = array
    end

    # Permet de modifier le nombre salles de diffusions d un objet Film.
    #
    # @param [Fixnum] nb - Le nombre de salles a ajouter aux films.
    #
    def salles=( nb )
      @salles = nb
    end

  end
end
