module GestionCine

  #
  # Module permettant de retrouver les differents Motifs
  # que l on peut retrouver dans une base de donnees.
  #
  module Motifs
    ID =  %r{\btt[0-9]{7}\b}
    JOUR = %r{\b[A-Z][a-z]{,7}\b}
    JOURS = %r{\b#{JOUR}-*\s*(#{JOUR})*\b}
    SALLES = %r{\b[0-9]+\b}

    FILM = %r{^(#{ID})\s*(#{SALLES})\s*(#{JOURS})*$}

  end
end
