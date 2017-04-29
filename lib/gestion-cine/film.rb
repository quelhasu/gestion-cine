module GestionAcademique


  class Film
    attr_reader :imdbid, :jours, :titre, :annee, :note,
                :genre, :real, :scenariste, :synopsis

    def initialize( imdbid, jours )
      film = OMDB.id(imdbid)
      @imdbid = imdbid
      @jours = jours
      @titre = film.title
      @annee = film.year
      @note = film.imdb_ratingsss
      @genre = film.genre
      @real = film.director
      @scenariste = film.writer
      @synopsis = film.plot
    end

  end
end
