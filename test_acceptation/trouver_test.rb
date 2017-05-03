require 'test_helper'

describe GestionCine do
  describe "trouver" do
    let(:json)  { '[]' }

    it_ "signale une erreur lorsque le fichier est inexistant" do
      FileUtils.rm_f '.db.json'
      genere_erreur( /fichier.*[.]db.json.*existe pas/ ) do
        gc( 'trouver' )
      end
    end

    it_ "retourne rien lorsque fichier vide" do
      avec_fichier '.db.json', [json] do
        execute_sans_sortie_ou_erreur do
          gc( 'trouver .' )
        end
      end
    end

    it_ "signale une erreur lorsqu'argument en trop" do
      avec_fichier '.db.json', [json] do
        genere_sortie_et_erreur( [], /Argument.*en trop/ ) do
          gc( 'trouver "." foo' )
        end
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


      it_ "trouve toutes les lignes avec un caractere quelconque" do
        avec_fichier '.db.json', lignes do
          genere_sortie( attendu ) do
            gc( 'trouver .' )
          end
        end
      end

      it_ "trouve toutes les lignes avec n importe quoi" do
        avec_fichier '.db.json', lignes do
          genere_sortie( attendu ) do
            gc( 'trouver ".*"' )
          end
        end
      end

      it_ "trouve les lignes matchant une chaine specifique mais parmi les actifs seulement" do
        avec_fichier '.db.json', lignes do
          attendu = '"Star Wars: The Force Awakens" (real. J.J. Abrams) - {Lundi-Jeudi-Vendredi} (3)',
                    '"Star Wars: The Last Jedi" (real. Rian Johnson) - {} ()'

          genere_sortie( attendu ) do
            gc( 'trouver star' )
          end
        end
      end

     it_ "affiche tous les films selon le format indique", :intermediaire do
        avec_fichier '.db.json', lignes do
          attendu = 'Star Wars: The Force Awakens => {Lundi-Jeudi-Vendredi} (136 min)',
                    'Star Wars: The Last Jedi => {} (N/A)'

          genere_sortie( attendu ) do
            gc( 'trouver --format="%T => {%J} (%M)" \'star\'')
          end
        end
      end
  end
  end
end
