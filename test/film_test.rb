require 'test_helper'
require 'gestion-cine'

module GestionCine
  describe Film do
    let(:erreurs_possibles) { [ArgumentError, RuntimeError, StandardError] }

    let(:tt2527336) { Film.new( :tt2527336, 3 , "Lundi", "Mardi", "Jeudi" ) }
    let(:tt3896198) { Film.new( :tt3896198 ) }
    let(:tt3315342) { Film.new( :tt3315342, 2,  "Vendredi", "Samedi" ) }

    describe ".new" do
      it_ "cree un film avec les attributs appropries" do
        tt2527336.imdbid.must_equal :tt2527336
        tt2527336.titre.must_equal 'Star Wars: The Last Jedi'
        tt2527336.jours.must_equal ["Lundi","Mardi","Jeudi"]
        tt2527336.salles.must_equal 3
      end

      it_ "cree un film non projete" do
        tt3896198.salles.must_equal 0
        tt3896198.jours.must_be_empty
      end

    end

    describe "#<=>" do
      it_ "retourne 0 par rapport a lui-meme" do
        (tt3896198 <=> tt3896198).must_equal 0
      end

      it_ "retourne -1 par rapport a un sigle plus grand" do
        (tt3896198 <=> tt2527336).must_equal( -1 )
      end

      it_ "retourne +1 par rapport a un sigle plus petit_" do
        (tt3315342 <=> tt3896198).must_equal 1
      end
    end

    describe "#to_s" do
      it_ "genere par defaut une forme simple avec des guillemets pour titre" do
        tt2527336.to_s.must_equal '"Star Wars: The Last Jedi" (real. Rian Johnson) - {Lundi-Mardi-Jeudi} (3)'
      end

      it_ "produit_ la chaine indiquee quand aucun format n'est specifie" do
        tt2527336.to_s( "ZUB" ).must_equal 'ZUB'
      end

      it_ "produit_ les bons elements, meme lorsqu'un it_em apparait_ plusieurs" do
        tt3315342.to_s( "%T (%A) %I %I" ).must_equal 'Logan (2017) tt3315342 tt3315342'
      end

      it_ "inclut les diverses chaines qui ne sont pas des formats" do
        tt3896198.to_s( "titre = '%T' realise par : %R en %A" ).must_equal "titre = 'Guardians of the Galaxy Vol. 2' realise par : James Gunn en 2017"
      end

      it_ "traite les justifications et la largeur maximum" do
        tt3315342.to_s( "%9T : %A" ).must_equal '    Logan : 2017'
      end

      it_ "assure que le format n'est pas modifie par une utilisation" do
        format = "%T (real. %R)"
        tt3315342.to_s( format ).must_equal 'Logan (real. James Mangold)'
        format.must_equal "%T (real. %R)"
      end

    end
  end
end
