module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def refresh_page
    visit current_url
  end

  def ckeditor_id(attribute)
    # Get the ckeditor id by taking another input's id and
    # changing the attribute in its id to the given attribute.
    # For nested forms, must be called in a block passed to `within`.
    # Pass the result into fill_in_ckeditor.
    # Usage:
    #
    # within all('.lesson-nested-fields')[0] do
    #  fill_in 'Name', with: 'Foobar'
    #  fill_in_ckeditor ckeditor_id('content'), with: 'Lorem ipsum dolor...'
    # end
    # e.g.
    #   model_description
    # ->
    #   model_`attribute`
    first('input').native.attributes['id'].split("_")[0..-2].push(attribute).join("_")
  end

  def fill_in_ckeditor(locator, opts)
    # Usage:
    #   fill_in_ckeditor ckeditor_id('content'), with: 'Lorem ipsum dolor...'
    content = opts.fetch(:with).to_json
    page.execute_script <<-SCRIPT
      CKEDITOR.instances['#{locator}'].setData(#{content});
      $('textarea##{locator}').text(#{content});
    SCRIPT
  end

  def click_in_datepicker(locator, text_to_click_on)
    find(locator).click
    within '#ui-datepicker-div' do
      find('a', text: /^#{text_to_click_on}$/).click
    end
  end

  RSpec::Matchers.define :appear_before do |later_content|
    match do |earlier_content|
      page.body.index(earlier_content) < page.body.index(later_content)
    end
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
