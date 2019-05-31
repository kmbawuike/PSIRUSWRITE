class Api::V1::CommentsController < ApplicationController
  before_action :load_article,only:[:index]
  before_action :authenticate_with_token!,only:[:create,:destroy]
  before_action :load_comment,only:[:show,:destroy]

  def index
    @comments = @article.comments
    json_response "Comments Loaded", true, {comments: @comments}, :ok
  end

  def show
    json_response "Comment loaded", true, {comment: @comment}, :ok
  end

  def create
    comment = Comment.create(comment_params)
    comment.article_id = params[:article_id]
    comment.user_id = current_user.id
    if comment.save
      json_response "Comment created Sucessfully", true, {comment: comment}, :ok
    else
      json_response "Comment was not created", false, {}, :unprocessable_entity
    end
  end

  def destroy
    if correct_user(@comment.user)
      if @comment.destroy
        json_response "Comment have been deleted", true, {}, :ok
      else
        json_response "Comment was not deleted", false, {}, :unprocessable_entity
      end
    else
      json_response "Unauthorized user", false, {}, :unauthorized
    end
  end

  private
  def load_article
    @article = Article.find_by(id: params[:article_id])
    unless @article.present?
      json_response "Article not found", false, {}, :not_found
    end
  end

  def load_comment
    @comment = Comment.find_by(id: params[:id])
    unless @comment.present?
      json_response "Comment not found", false, {}, :not_found
    end
  end

  def comment_params
    params.require(:comment).permit(:body,:image)
  end
end
