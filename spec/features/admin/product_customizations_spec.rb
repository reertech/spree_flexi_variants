require 'spec_helper'

describe 'Product Customizations', js: true do
  describe 'test add links / remove links / add options values / remove options values/ update and cancel buttons' do
    extend Spree::TestingSupport::AuthorizationHelpers::Request
    include IntegrationHelpers
    stub_authorization!

    before do
      @test_product = create(:product, name: 'Test Product', price: 12.99)
    end

    def create_product_customization_type
      create(:product_customization_type, name: 'custom_name', presentation: 'Custom_present')
    end

    def go_to_product_customization
      click_on('Customization Types')
      expect(page).to have_content('New Product Customization Type')
    end

    it 'product customization add/remove existing customization types' do
      create_product_customization_type
      go_to_product_page
      go_to_product_customization

      click_on('New Product Customization Type')
      fill_in('Name', :with => 'John')
      fill_in('Presentation', :with => 'Zolupa')
      find('.icon.icon-ok').click
      visit '/admin'
      click_on 'Products'
      click_on 'Customization Types'
      expect(all('#product_customization_types tbody tr').length).to eq(2)

      #test remove
      page.accept_alert 'Are you sure?' do
        find('.icon.icon-delete').click
      end

      expect(page).to have_content("Product customization type \"custom_name\" has been successfully removed!")
      expect(page).to have_content('Name Presentation Description John Zolupa')
      expect(page).not_to have_content('Name Presentation Description custom_name Custom_present')
    end

  end
end

# save_and_open_page
# save_and_open_screenshot
