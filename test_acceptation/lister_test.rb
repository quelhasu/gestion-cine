require 'test_helper'

describe GestionCine do
  describe "lister" do
    it_ "signale une erreur lorsque le fichier est inexistant" do
      FileUtils.rm_f '.db.json'
      genere_erreur( /fichier.*[.]db.json.*existe pas/ ) do
        gc( 'lister' )
      end
    end

    it_ "liste un fichier vide" do
      avec_fichier '.db.json'do
        genere_erreur( /.*A JSON text must at least contain two octets!.*/ ) do
          gc( 'lister' )
        end
      end
    end

    it_ "liste les films par defaut" do
      lignes = IO.readlines("#{REPERTOIRE_TESTS}/db6.json")
      attendu =  '"Schindler\'s List" (real. Steven Spielberg) - {Mardi} (1)',
                 '"Star Wars: The Force Awakens" (real. J.J. Abrams) - {Lundi-Jeudi-Vendredi} (3)',
                 '"Star Wars: The Last Jedi" (real. Rian Johnson) - {} ()',
                 '"The Dark Knight" (real. Christopher Nolan) - {Mercredi-Samedi-Dimanche} (0)',
                 '"The Godfather" (real. Francis Ford Coppola) - {Lundi-Mardi-Mercredi-Dimanche} (4)',
                 '"The Lord of the Rings: The Return of the King" (real. Peter Jackson) - {Lundi-Dimanche} (10)'


      avec_fichier '.db.json', lignes do
        genere_sortie( attendu ) do
          gc( 'lister' )
        end
      end
    end

    it_ "liste les films sorties en decembre" do
      lignes = IO.readlines("#{REPERTOIRE_TESTS}/db6.json")
      attendu = '"Star Wars: The Force Awakens" (real. J.J. Abrams) - {Lundi-Jeudi-Vendredi} (3)',
                 '"Star Wars: The Last Jedi" (real. Rian Johnson) - {} ()',
                 '"The Lord of the Rings: The Return of the King" (real. Peter Jackson) - {Lundi-Dimanche} (10)'


      avec_fichier '.db.json', lignes do
        genere_sortie( attendu ) do
          gc( 'lister --mois=decembre ' )
        end
      end
    end

    it_ "liste les films avec l option note indique" do
      lignes = IO.readlines("#{REPERTOIRE_TESTS}/db6.json")
      attendu = '"Star Wars: The Force Awakens" (real. J.J. Abrams) - {Lundi-Jeudi-Vendredi} (3)',
                '"Schindler\'s List" (real. Steven Spielberg) - {Mardi} (1)',
                '"The Lord of the Rings: The Return of the King" (real. Peter Jackson) - {Lundi-Dimanche} (10)',
                '"The Dark Knight" (real. Christopher Nolan) - {Mercredi-Samedi-Dimanche} (0)',
                '"The Godfather" (real. Francis Ford Coppola) - {Lundi-Mardi-Mercredi-Dimanche} (4)',
                 '"Star Wars: The Last Jedi" (real. Rian Johnson) - {} ()'


      avec_fichier '.db.json', lignes do
        genere_sortie( attendu ) do
          gc( 'lister --option=note ' )
        end
      end
    end

    it_ "liste les films avec l option top indique et un format explicite" do
      lignes = IO.readlines("#{REPERTOIRE_TESTS}/db6.json")
      attendu =  '15 Dec 2017:: "Star Wars: The Last Jedi" () => ',
                 '18 Dec 2015:: "Star Wars: The Force Awakens" (3) => Lundi-Jeudi-Vendredi',
                 '18 Jul 2008:: "The Dark Knight" (0) => Mercredi-Samedi-Dimanche',
                 '17 Dec 2003:: "The Lord of the Rings: The Return of the King" (10) => Lundi-Dimanche',
                 '04 Feb 1994:: "Schindler\'s List" (1) => Mardi',
                 '24 Mar 1972:: "The Godfather" (4) => Lundi-Mardi-Mercredi-Dimanche'


      avec_fichier '.db.json', lignes do
        genere_sortie( attendu ) do
          gc( 'lister --option=annee --format="%O:: \"%T\" (%S) => %J"' )
        end
      end
    end

    it_ "liste les films avec l option duree indique et un format explicite" do
      lignes = IO.readlines("#{REPERTOIRE_TESTS}/db6.json")
      attendu =  '"Star Wars: The Force Awakens" (136 min)',
                 '"The Dark Knight" (152 min)',
                 '"The Godfather" (175 min)',
                 '"Schindler\'s List" (195 min)',
                 '"The Lord of the Rings: The Return of the King" (201 min)',
                 '"Star Wars: The Last Jedi" (N/A)'


      avec_fichier '.db.json', lignes do
        genere_sortie( attendu ) do
          gc( 'lister --option=duree --format="\"%T\" (%M)"' )
        end
      end
    end
  end
end
