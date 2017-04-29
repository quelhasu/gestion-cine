module GestionCine

class BanqueDeCours


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
    @les_films = data_hash["film-collection"]
      . map { |e| GestionCine::FilmJson.creer_film(e) }
    end
  end



end
