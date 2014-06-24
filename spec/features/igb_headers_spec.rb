require 'rails_helper'

feature "IgbHeaders", :type => :feature do
  describe "Scan Tool Requires IGB" do
    it "shows a flash message about IGB requirement" do
      visit scans_path
      expect(page).to have_content('This portion of the site requires IGB access with trust enabled')
    end
    it "just loads when the all IGB headers are present" do      
      page.driver.browser.header('User-Agent', 'EVE-IGB')
      page.driver.browser.header('EVE_TRUSTED', 'Yes')
      page.driver.browser.header('EVE_CHARID', 'Yes')
      page.driver.browser.header('EVE_CORPID', 'Yes')
      page.driver.browser.header('EVE_ALLIANCEID', 'Yes')
      page.driver.browser.header('EVE_SOLARSYSTEMID', 'Yes')
      visit scans_path
      expect(page).to have_content("You don't seem to have any scans. Add a new one below!")
    end
    it "redirects to IGB trust request page if not all headers are present and UserAgent is IGB" do
      page.driver.browser.header('User-Agent', 'EVE-IGB')
      visit scans_path
      expect(page).to have_content('In order to be able to get the your details needed to store the scan results: HTTP_EVE_CHARID, HTTP_EVE_CORPID, HTTP_EVE_ALLIANCEID, HTTP_EVE_SOLARSYSTEMID, IGB trust is needed')
    end
  end
end
