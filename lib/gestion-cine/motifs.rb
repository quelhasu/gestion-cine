module GestionCine

  module Motifs
    ID =  %r{\btt[0-9]{7}\b}
    JOUR = %r{\b[A-Z][a-z]{,7}\b}
    JOURS = %r{\b#{JOUR}-*\s*(#{JOUR})*\b}
    SALLES = %r{\b[0-9]+\b}

    FILM = %r{^(#{ID})\s*(#{JOURS})*\s*(#{SALLES})$}

  end
end
