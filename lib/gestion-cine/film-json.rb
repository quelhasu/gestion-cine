module GestionCine


  module FilmJson

    SEPARATEUR_JOURS = "-"

    # Methode pour creer un objet Film pour chaque ligne presente dans le depot
    def self.creer_film( ligne )
      imdbid = ligne["imdbid"]
      jours = ligne["jours"]
      salles = ligne["salles"]

      Film.new(imdbid, salles , jours)
    end

    # Methode pour renvoyer un objet Cours au format JSON
    def self.transformer( film )
      jours = film.jours
      salles = film.salles
      id = film.imdbid
      a = {:imdbid => id, :jours => jours, :salles => salles}
    end

  end
end
