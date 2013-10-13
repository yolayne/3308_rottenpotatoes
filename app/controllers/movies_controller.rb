class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index


    @all_ratings = Movie.all_ratings
    redirect = false

    if params[:ratings] == nil
      if session[:ratings] != nil
        flash.keep
        params[:ratings] = session[:ratings]
        redirect = true
      end
    else
      session[:ratings] = params[:ratings]
    end

    if params[:sort] == nil
      if session[:sort] != nil
        flash.keep
        params[:sort] = session[:sort]
        redirect = true
      end
    else
      session[:sort] = params[:sort]
    end

    if redirect == true
      redirect_to :sort => session[:sort], :ratings => session[:ratings], :commit => params[:commit]
    end

    @sort = params[:sort]
    if params[:ratings] != nil
      @checked_ratings = params[:ratings] 
    else
      @checked_ratings = @all_ratings
    end

    if @sort.nil?
      if @checked_ratings.nil?
        @movies = Movie.all
      elsif @checked_ratings == @all_ratings
        @movies = Movie.find(:all, :conditions => {:rating => @checked_ratings})
      else
        @movies = Movie.find(:all, :conditions => {:rating => @checked_ratings.keys})
      end
    else
      if @checked_ratings != params[:ratings]
        @movies = Movie.find(:all, :order => @sort)
      elsif @checked_ratings == @all_ratings
        @movies = Movie.find(:all, :order => @sort, :conditions => { :rating => @checked_ratings})
      else
        @movies = Movie.find(:all, :order => @sort, :conditions => { :rating => @checked_ratings.keys})
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
