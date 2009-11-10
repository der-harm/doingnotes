Given 'I save' do
  system "couchapp push #{database}"
end

When /^show the "([^\"]*)" div$/ do |name|
  p $browser.div(name).html
end

When /^I hit "([^\"]*)" in a text_field with id "([^\"]*)"$/ do |key, id|
  key_code = case key
    when 'enter'
      13
    when 'up'
      38
    when 'down'
      40
    else
      0
    end
  $browser.execute_script('event = document.createEvent("KeyboardEvent");')
  $browser.execute_script('event.initKeyEvent("keydown", true, false, document.window, false, false, false, false, ' + key_code.to_s + ', 0)')
  $browser.execute_script("document.getElementById('#{id}').dispatchEvent(event)")
  When 'I wait for the AJAX call to finish'
end

Then /^I should see "([^\"]*)" before "([^\"]*)"$/ do |first, second|
  div = $browser.div('container')
  unless div.html.match(/#{first}.*#{second}/im) 
    raise("#{first} can't be found before #{second}") 
  end
end

# Then /^I should see "([^\"]*)" twice$/ do |text|
#   regexp = Regexp.new(text + "(.+)" + text)
#   response.body.should contain(regexp)
# end

Then /^I should see "([^\"]+)" in a li with class "([^\"]+)"$/ do |text, css_class|  
  li = $browser.li(:class, css_class)
  # puts li.html
  unless li.html.match(/text/im) 
    raise("#{text} can't be found in li #{css_class}") 
  end
 # puts  find_element(type.to_sym, name).html
 #  find_element(type.to_sym, name).html should include(text)
end

Then /^I should see a li with id "([^\"]*)"$/ do |id|
  $browser.li(:id, id).attribute_value(:id).should include(id)
end

Then /^I should see a blank li with id "([^\"]+)"$/ do |id|
  li = $browser.li(:id, id)
  unless li.html.match(/>\s*<\/textarea>/) 
    raise("li #{id} is not blank") 
  end  
end

# Then /^"([^\"]*)" should have the class "([^\"]*)"$/ do |element_id, css_class|
#   find_element(:text_field, element_id).attribute_value(:class).should include(css_class)
# end
# 
# Then /^"([^\"]*)" should not have the class "([^\"]*)"$/ do |element_id, css_class|
#   find_element(:text_field, element_id).attribute_value(:class).should_not include(css_class)
# end

def find_element(type, attribute)
  matchers = [[attribute, :id], [attribute, :name]]
  matchers << [$browser.label(:text, attribute).for, :id] if $browser.label(:text, attribute).exist?
  matchers.map{ |field, matcher| 
    $browser.send(type, matcher, field)
  }.find(&:exist?) ||  raise("#{type} '#{attribute}' not found")
end