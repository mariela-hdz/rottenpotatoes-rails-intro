class Movie < ActiveRecord::Base
  def self.all_ratings()
    ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    if ratings_list == []
      Movie.all
    else
      Movie.where(rating: ratings_list)
    end
    # Student.where(grade: [9,11,12])
    # where("rating" is in movie in movie db has a rating that matches an item in ratings_list)
  end
end
