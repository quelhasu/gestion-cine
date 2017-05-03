require 'test_helper'

describe GestionCine do
  let(:bd)  { '.db.json' }
  let(:json)  { '[]' }

  describe "modifier" do

    it_ "signale une erreur lorsque depot inexistant" do
      FileUtils.rm_f bd
      genere_erreur( /fichier.*[.]db.json.*existe pas/ ) do
        gc( 'modifier --salles=2 tt4649466 ' )
      end
    end

    it_ "signale une erreur lorsque l'id est invalide" do
      avec_fichier bd, [json] do
        genere_erreur( /ID.*incorrect/ ) do
          gc( 'modifier --salles=2 id4649466' )
        end
      end
    end

    it_ "signale une erreur lorsqu'aucune option est indique" do
      avec_fichier bd, [json] do
        genere_erreur( /Aucune option/ ) do
          gc( 'modifier tt4649466' )
        end
      end
    end

    context "banque de films avec plusieurs films" do
      let(:lignes) { IO.readlines("#{REPERTOIRE_TESTS}/db6.json") }

      it_ "modifie un film en ajoutant 2 salles" do
        nouveau_contenu = avec_fichier bd, lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            gc( "modifier --salles=2 tt2488496 " )
          end
        end

        nouveau_contenu[8]
          .must_equal "    \"salles\": 5"

        FileUtils.rm_f bd
      end

      it_ "modifie un film en ajoutant 2 salles et un jour" do
        nouveau_contenu = avec_fichier bd, lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            gc( 'modifier --salles=2 --jours="Samedi" tt2488496 ' )
          end
        end

        nouveau_contenu[7]
          .must_equal "      \"Samedi\""
        nouveau_contenu[9]
          .must_equal "    \"salles\": 5"

        FileUtils.rm_f bd
      end

      it_ "modifie un film en ajoutant 2 jours" do
        nouveau_contenu = avec_fichier bd, lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            gc( 'modifier --jours="Dimanche Mardi" tt2488496 ' )
          end
        end

        nouveau_contenu[8]
          .must_equal "      \"Mardi\""

        FileUtils.rm_f bd
      end

      it_ "signale une erreur lorsqu'un jour indique est deja present" do
        avec_fichier bd, lignes do
          genere_erreur( /Jour deja present/ ) do
            gc( 'modifier --jours="Lundi" tt2488496 ' )
          end
        end
      end
    end

    context "banque de films autre que celui par defaut" do
      let(:lignes) { IO.readlines("#{REPERTOIRE_TESTS}/db6.json") }
      let(:fichier) { '.foo.json' }

      it_ "signale une erreur lorsque le depot est inexistant" do
        FileUtils.rm_f fichier
        genere_erreur( /fichier.*existe pas/ ) do
          gc( '--depot=#{fichier} modifier --jours="Dimanche Mardi" tt2488496' )
        end
      end

      it_ "modifie un film" do
        imdbid = 'tt2488496'
        salles = '3'
        jours = 'Samedi'

        nouveau_contenu = avec_fichier fichier, lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            gc( "--depot=#{fichier} modifier --salles=#{salles} --jours=#{jours} #{imdbid}" )
          end
        end

        nouveau_contenu[7]
          .must_equal "      \"Samedi\""
        nouveau_contenu[9]
          .must_equal "    \"salles\": 6"

        FileUtils.rm_f fichier
      end

   end
 end
end
