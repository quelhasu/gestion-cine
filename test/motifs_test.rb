require 'test_helper'
require 'gestion-cine'

module GestionCine
  describe Motifs do
    describe Motifs::ID do
      it_ "matche un id correct" do
        "tt2488496".must_match Motifs::ID
      end

      it_ "ne matche pas un id trop court" do
        "tt248849".wont_match Motifs::ID
      end

      it_ "ne matche pas un id trop long" do
        "tt2488496823".wont_match Motifs::ID
      end

      it_ "ne matche pas un id incorrect" do
        "id2817232".wont_match Motifs::ID
      end
    end


    describe Motifs::JOURS do
      it_ "ne matche pas 0 jour" do
        "".wont_match Motifs::JOURS
      end

      it_ "matche 1 jour" do
        "Dimanche".must_match Motifs::JOURS
      end

      it_ "matche 2 jours" do
        "Dimanche-Lundi".must_match Motifs::JOURS
      end
    end

    describe Motifs::SALLES do
      it_ "ne matche pas 0 salle" do
        "".wont_match Motifs::SALLES
      end

      it_ "matche 1 salle" do
        "1".must_match Motifs::SALLES
      end

      it_ "matche 2 salles" do
        "2::1".must_match Motifs::SALLES
      end
    end

    describe Motifs::FILM do
      it_ "matche un film complet" do
        "tt2488496 3 Lundi-Mardi-Jeudi".must_match Motifs::FILM
      end

    end
  end
end
