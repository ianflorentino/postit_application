class CommentsController < ApplicationController
before_action :require_user
  
  def create
    @post            = Post.find(params[:post_id])
    @comment         = Comment.new(comment_params)
    @comment.post    = @post
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Comment was added"
      redirect_to post_path(@post)
    else
      render '/posts/show'
    end
  end

  def vote
    comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: comment, creator: current_user, vote: params[:vote])

    if @vote.valid?
      flash[:notice] = "Vote completed"
    else
      flash[:error] = "Vote Denied. Cannot vote more than once for a particular Post/Comment"
    end

    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end 