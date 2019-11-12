require "application_system_test_case"

class AdvertisementsTest < ApplicationSystemTestCase
  setup do
    @advertisement = advertisements(:one)
  end

  test "visiting the index" do
    visit advertisements_url
    assert_selector "h1", text: "Advertisements"
  end

  test "creating a Advertisement" do
    visit advertisements_url
    click_on "New Advertisement"

    fill_in "Body", with: @advertisement.body
    check "Published" if @advertisement.published
    fill_in "Title", with: @advertisement.title
    click_on "Create Advertisement"

    assert_text "Advertisement was successfully created"
    click_on "Back"
  end

  test "updating a Advertisement" do
    visit advertisements_url
    click_on "Edit", match: :first

    fill_in "Body", with: @advertisement.body
    check "Published" if @advertisement.published
    fill_in "Title", with: @advertisement.title
    click_on "Update Advertisement"

    assert_text "Advertisement was successfully updated"
    click_on "Back"
  end

  test "destroying a Advertisement" do
    visit advertisements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Advertisement was successfully destroyed"
  end
end
