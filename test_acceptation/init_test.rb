require 'test_helper'
require 'gestion-cine'

DEFAUT=".db.json"

describe GestionCine do
  [DEFAUT, '.foo.json'].each do |depot|
    argument_depot = depot == DEFAUT ? ''    : "--depot=#{depot} "

    describe "init" do
      after  { FileUtils.rm_f depot }

      context "le depot #{depot} n'existe pas" do
        before { FileUtils.rm_f depot }

        it_ "cree le depot #{depot} lorsqu'aucune option n'est specifiee" do
          execute_sans_sortie_ou_erreur do
            gc( "#{argument_depot}init" )
          end
          assert File.zero? depot
        end

        it_ "cree le depot #{depot} lorsque l'option --detruire est specifies" do
          execute_sans_sortie_ou_erreur do
            gc( "#{argument_depot}init --detruire" )
          end
          assert File.zero? depot
        end
       end
  end
end
end
