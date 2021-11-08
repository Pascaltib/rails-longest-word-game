require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector ".char-box", count: 10
  end

  test "You can fill the form with a random word, click the play button, and get a message that the word is not in the grid" do
    visit new_url
    find('input').set('beautiful')
    click_on("Play")
    assert_selector "p", text: /.*can't\sbe\sbuilt.*/
  end

end
