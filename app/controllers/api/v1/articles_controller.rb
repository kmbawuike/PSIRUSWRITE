class Api::V1::ArticlesController < ApplicationController
  before_action :load_collection,only:[:index, :create]
  before_action :load_article,only:[:show,:update,:destroy]
  before_action :authenticate_with_token!,only:[:create,:update,:destroy]



  def index
    @articles = @collection.articles
    article_serializer = parse_json(@articles)
    json_response "Articles loaded Sucessfully", true, {articles: article_serializer}, :ok

  end

  def show
    article_serializer = parse_json(@article)
    json_response "Article loaded Sucessfully", true, {article: article_serializer}, :ok
  end

  def create
    article = Article.create(article_params)
    article.user_id = current_user.id
    article.collection_id = params[:collection_id]
    if @collection.user.id == article.user_id
      if article.save
        article_serializer = parse_json(article)
        json_response "Article created Successfully", true, {article: article_serializer}, :ok
      else
        json_response "Article not created", false, {}, :unprocessable_entity
      end
    else
      json_response "Unauthorized User", false, {}, :unauthorized
    end

  end

  def update
    if correct_user(@article.user)
      if @article.update(article_params)
        article_serializer = parse_json(@article)
        json_response "Article updated Sucessfully", true, {article: article_serializer}, :ok
      else
        json_response "Article was not updated", false, {}, :unprocessable_entity
      end
    else
      json_response "Unauthorized", false, {}, :unauthorized
    end
  end

  def destroy
    if correct_user(@article.user)
      if @article.destroy
        json_response "Article destroyed Sucessfully", true, {}, :ok
      else
        json_response "Article was not deleted", false, {}, :unprocessable_entity
      end
    else
      json_response "Unauthorized", false, {}, :unauthorized
    end
  end

  private
  def load_collection
    @collection = Collection.find_by(id: params[:collection_id])
    unless @collection.present?
      json_response "Collection not found", false, {}, :not_found
    end
  end

  def load_article
    @article = Article.find_by(id: params[:id])
    unless @article.present?
      json_response "Article not found", false, {}, :not_found
    end
  end

  def article_params
    params.require(:article).permit(:title, :image, :body, :article_image)
  end

end
