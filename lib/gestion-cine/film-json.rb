module GestionCine

  # Module permettant de creer un film a partir d une ligne envoyee
  # et permet  de transformer un objet Film en hashmap pour pouvoir
  # l exporter dans un fichier Json.
  #
  module FilmJson
    # Separateur pour les jours de diffusions d un film.
    SEPARATEUR_JOURS = "-"

    # Methode pour creer un objet Film pour chaque ligne presente dans le depot
    # a partir des lignes presentes dans le fichier Json.
    #
    # @param [hashmap] ligne - ligne presente sous forme de hash.
    #
    def self.creer_film( ligne )
      imdbid = ligne["imdbid"]
      jours = ligne["jours"]
      salles = ligne["salles"]

      Film.new(imdbid, salles , jours)
    end

    # Methode pour renvoyer un objet Film au format JSON.
    #
    # @param [Film] film - objet film a transformer en objet hashmap.
    #
    def self.transformer( film )
      jours = film.jours
      salles = film.salles
      id = film.imdbid
      hash = {:imdbid => id, :jours => jours, :salles => salles}
    end

  end
end
