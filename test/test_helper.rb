gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'open3'

#########################################################
# Methodes auxiliaires pour les tests du devoir 2.
#########################################################

#
# Extensions de la classe Object pour definir des methodes auxiliaires
# de test.
#
class Object
  # Pour desactiver temporairement une suite de tests.
  def _describe( test )
    puts "--- On saute les tests pour \"#{test}\" ---"
  end

  # Pour desactiver temporairement un test.
  def _it( test )
    puts "--- On saute les tests pour \"#{test}\" ---"
  end

  # Pour desactiver temporairement un test.
  def _it_( test, niveau = :base )
    puts "--- On saute le test \"#{test}\" ---"
  end

  # Des alias pour style RSpec
  alias_method :context, :describe
  alias_method :_context, :_describe


  # Une methode de test auxiliaire pour tenir compte du niveau de test
  # en cours.
  def it_( test, niveau = :base, &bloc )
    return if (niveau_a_tester = ENV['NIVEAU']) && niveau_a_tester.to_sym != niveau

    it( test, &bloc )
  end
end
