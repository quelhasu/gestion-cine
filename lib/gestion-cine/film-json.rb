module GestionCine


  module FilmJson

    SEPARATEUR_JOURS = "-"

    # Methode pour creer un objet Film pour chaque ligne presente dans le depot
    def self.creer_film( ligne )
      imdbid = ligne["imdbid"]
      jours = ligne["jours"]
      Film.new(imdbid, jours.join(SEPARATEUR_JOURS))
    end

  end
end
