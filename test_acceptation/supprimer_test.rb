require 'test_helper'

describe GestionCine do
  let(:bd)  { '.db.json' }

  describe "supprimer" do
    it_ "signale une erreur lorsque depot inexistant" do
      FileUtils.rm_f bd
      genere_erreur( /fichier.*[.]db.json.*existe pas/ ) do
        gc( 'supprimer tt2488496' )
      end
    end

    context "banque de films avec plusieurs films" do
      let(:lignes) { IO.readlines("#{REPERTOIRE_TESTS}/db6.json") }
      let(:attendu) { ['"Schindler\'s List" (real. Steven Spielberg) - {Mardi} (1)',
                      '"Star Wars: The Force Awakens" (real. J.J. Abrams) - {Lundi-Jeudi-Vendredi} (3)',
                      '"Star Wars: The Last Jedi" (real. Rian Johnson) - {} ()',
                      '"The Dark Knight" (real. Christopher Nolan) - {Mercredi-Samedi-Dimanche} (0)',
                      '"The Godfather" (real. Francis Ford Coppola) - {Lundi-Mardi-Mercredi-Dimanche} (4)',
                      '"The Lord of the Rings: The Return of the King" (real. Peter Jackson) - {Lundi-Dimanche} (10)']}

      it_ "signale une erreur lorsque le sigle n'existe pas" do
        avec_fichier bd, lignes do
          genere_erreur( /Aucun film.*tt2488498/ ) do
            gc( "supprimer tt2488498" )
          end
        end
      end

      it_ "signale une erreur lorsqu'il y a un argument en trop" do
        avec_fichier bd, lignes do
          genere_sortie_et_erreur( [], /Argument.*en trop/ ) do
            gc( 'supprimer tt2488496 foo' )
          end
        end
      end
    end
  end
end
