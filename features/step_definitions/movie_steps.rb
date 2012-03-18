Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.find_or_create_by_title_and_rating_and_release_date \
    movie[:title], movie[:rating], movie[:release_date]
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  titles = page.all(:xpath, "//table[@id='movies']/tbody/tr/td[1]").collect do |element|
    element.text
  end

  assert titles.index(e1) < titles.index(e2)
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(', ').each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating}"}
  end
end

Then /I should see (all|none) of the movies/ do |quantifier|
  mode = 'not ' if quantifier == 'none'

  Movie.all.each do |movie|
    step %Q{I should #{mode}see "#{movie.title}"}
  end
end
