class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  #1. setup an instance variable for action
  #2. redirect away from an action

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
  end

  def show  
    @comment = Comment.new
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    if @vote.valid?
      flash[:notice] = "Vote completed"
    else
      flash[:error] = "Vote Denied. Cannot vote more than once for a particular Post/Comment"
    end

    redirect_to :back
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path
    else
      render :new
    end

  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "The post was updated"
      redirect_to posts_path
    else
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
