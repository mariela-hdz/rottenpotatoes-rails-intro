class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:commit] == "Refresh" && params[:ratings].blank?
      session.delete(:ratings)
      @ratings_to_show = []
    elsif params[:ratings]
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = @ratings_to_show
    elsif session[:ratings]
      @ratings_to_show = session[:ratings]
#       redirect_to action: :index, ratings: session[:ratings].to_h {|s| [s, 1]}, sortByMovieTitle: session[:sortByMovieTitle], sortByReleaseDate: session[:sortByReleaseDate]
    else 
      @ratings_to_show = @all_ratings
    end

    if params[:sortByMovieTitle]
      @movies = Movie.with_ratings(@ratings_to_show).order(:title)
      @clickedTitle = "bg-warning"
      session[:sortByMovieTitle] = true
      session[:sortByReleaseDate] = false
    elsif params[:sortByReleaseDate]
      @movies = Movie.with_ratings(@ratings_to_show).order(:release_date)
      @clickedRelease = "bg-warning"
      session[:sortByReleaseDate] = true
      session[:sortByMovieTitle] = false
    elsif session[:sortByMovieTitle]
      @movies = Movie.with_ratings(@ratings_to_show).order(:title)
      @clickedTitle = "bg-warning"
      redirect_to action: :index, sortByMovieTitle: true, ratings: session[:ratings]&.to_h {|s| [s, 1]} || {}
    elsif session[:sortByReleaseDate]
      @movies = Movie.with_ratings(@ratings_to_show).order(:release_date)
      @clickedRelease = "bg-warning"
      redirect_to action: :index, sortByReleaseDate: true, ratings: session[:ratings]&.to_h {|s| [s, 1]} || {}
    elsif params[:ratings]
      @movies = Movie.with_ratings(@ratings_to_show)
    elsif session[:ratings]
      @movies = Movie.with_ratings(@ratings_to_show)
      redirect_to action: :index, sortByReleaseDate: false, sortByMovieTitle: false, ratings: session[:ratings]&.to_h {|s| [s, 1]} || {}
    else
      @movies = Movie.with_ratings(@ratings_to_show)
      session.delete(:sortByMovieTitle)
      session.delete(:sortByReleaseDate)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
