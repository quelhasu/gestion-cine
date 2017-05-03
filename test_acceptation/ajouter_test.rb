require 'test_helper'

describe GestionCine do
  let(:bd)  { '.db.json' }
  let(:json)  { '[]' }
  let(:separateur_jours)  { GestionCine::FilmJson::SEPARATEUR_JOURS }

  describe "ajouter" do
    it_ "ajoute dans un fichier vide" do
      nouveau_contenu = avec_fichier bd, [json], :conserver  do
        execute_sans_sortie_ou_erreur do
          gc( 'ajouter tt4649466 3 "Lundi" ' )
        end
      end

      nouveau_contenu.size.must_equal 9
      nouveau_contenu[2].must_equal "    \"imdbid\": \"tt4649466\","
      FileUtils.rm_f bd
    end

    it_ "signale une erreur lorsque depot inexistant" do
      FileUtils.rm_f bd
      genere_erreur( /fichier.*[.]db.json.*existe pas/ ) do
        gc( 'ajouter tt4649466 3 "Lundi" ' )
      end
    end

    it_ "signale une erreur lorsque l'id est invalide" do
      avec_fichier bd, [json] do
        genere_erreur( /ID.*incorrect/ ) do
          gc( 'ajouter id4649466 3 "Lundi" ' )
        end
      end
    end

    it_ "signale une erreur lorsqu'un prealable est invalide au niveau du sigle" do
      avec_fichier bd, [json] do
        genere_erreur( /Jour.*incorrect/ ) do
          gc( 'ajouter tt4649466 3 "Lundimanche" ' )
        end
      end
    end


    context "banque de films avec plusieurs films" do
      let(:lignes) { IO.readlines("#{REPERTOIRE_TESTS}/db6.json") }

      it_ "ajoute un film s'il n'existe pas" do
        imdbid = 'tt4649466'
        salles = '3'
        jours = 'Lundi'

        nouveau_contenu = avec_fichier bd, lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            gc( "ajouter #{imdbid} #{salles} #{jours}" )
          end
        end

        nouveau_contenu[-7]
          .must_equal "    \"imdbid\": \"tt4649466\","

        FileUtils.rm_f bd
      end


      it_ "signale une erreur lorsqu'un jour est incorrect" do
        avec_fichier bd, [json] do
          genere_erreur( /Jour.*incorrect/ ) do
            gc( 'ajouter tt4649466 3 "Lundimanche" ' )
          end
        end
      end


      it_ "signale une erreur lorsqu'le film existe deja" do
        avec_fichier bd, lignes do
          genere_erreur( /le meme imdbid existe deja/ ) do
            gc( 'ajouter tt2488496 3 "Lundi" "Mardi" ' )
          end
        end
      end
     end

    context "banque de films autre que celui par defaut" do
      let(:lignes) { IO.readlines("#{REPERTOIRE_TESTS}/db6.json") }
      let(:fichier) { '.foo.json' }

      it_ "signale une erreur lorsque le depot est inexistant" do
        FileUtils.rm_f fichier
        genere_erreur( /fichier.*#{fichier}.*existe pas/ ) do
          gc( "--depot=#{fichier} ajouter INF120 ajouter tt4649466 3 \"Lundi\"" )
        end
      end

      it_ "ajoute un film lorsqu'il n'existe pas" do
        imdbid = 'tt4649466'
        salles = '3'
        jours = 'Lundi'

        nouveau_contenu = avec_fichier fichier, lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            gc( "--depot=#{fichier} ajouter #{imdbid} #{salles} #{jours}" )
          end
        end

        nouveau_contenu[-7]
          .must_equal "    \"imdbid\": \"tt4649466\","

        FileUtils.rm_f fichier
      end

   end

  context "ajout de film specifie sur stdin" do
    let(:lignes) { IO.readlines("#{REPERTOIRE_TESTS}/db6.json") }

    it_ "ajoute un film sans jours" do
      imdbid = 'tt4649466'
      salles = '3'

      avec_fichier 'data.json', ["#{imdbid} #{salles}"] do
        nouveau_contenu = avec_fichier bd, lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            gc( "ajouter < data.json" )
          end
        end

        nouveau_contenu[-7]
          .must_equal "    \"imdbid\": \"tt4649466\","
      end

      FileUtils.rm_f bd
    end

    it_ "ajoute un film avec jours lorsqu'il n'existe pas" do
      imdbid = 'tt4649466'
      salles = '3'
      jours = 'Lundi Mardi'

      avec_fichier 'data.json', ["  #{imdbid}  #{salles} #{jours} "] do
        nouveau_contenu = avec_fichier bd, lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            gc( "ajouter < data.json" )
          end
        end

        nouveau_contenu[-7]
          .must_equal "    \"imdbid\": \"tt4649466\","
      end

      FileUtils.rm_f bd
    end

    it_ "ajoute plusieurs films lorsqu'ils n'existent pas" do
      imdbid = 'tt4649466'
      salles = '3'
      jours = 'Lundi Mardi'

      imdbid2 = 'tt0107688'
      salles2 = '1'
      jours2 = 'Vendredi Samedi Dimanche'

      avec_fichier 'data.txt', ["#{imdbid} #{salles} #{jours}",
                                "",
                                "#{imdbid2} #{salles2} #{jours2}",
                                "      ",
                               ] do
        nouveau_contenu = avec_fichier bd, lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            gc( "ajouter < data.txt" )
          end
        end

        nouveau_contenu[-14]
          .must_equal "    \"imdbid\": \"tt4649466\","

        nouveau_contenu[-7]
          .must_equal "    \"imdbid\": \"tt0107688\","
      end

      FileUtils.rm_f bd
    end

    it_ "n'ajoute rien si un des films specifie a des erreurs" do
      imdbid = 'tt4649466'
      salles = '3'
      jours = 'Lundi Mardi'

      imdbid2 = 'id0107688'
      salles2 = '1'
      jours2 = 'Vendredi Samedi Dimanche'

      avec_fichier 'data.txt', ["#{imdbid} #{salles} #{jours}",
                                "",
                                "#{imdbid2} #{salles2} #{jours2}",
                                "      ",
                               ] do
        avec_fichier bd, lignes, :conserver do
          FileUtils.cp bd, "#{bd}.avant"
          genere_erreur( /Format incorrect.*/ ) do
            gc( "ajouter < data.txt" )
          end
        end

        %x{cmp #{bd} #{bd}.avant; echo $?}.must_equal "0\n"
      end

      FileUtils.rm_f bd
      FileUtils.rm_f "#{bd}.avant"
     end
   end
 end
end
