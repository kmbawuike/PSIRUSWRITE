class Api::V1::CollectionsController < ApplicationController
  before_action :load_collection,only: [:show,:update,:destroy]
  before_action :authenticate_with_token!,only:[:create,:update,:destroy]

  def index
    collections = Collection.all.order(created_at: :desc)
    json_response "Collections Loaded Successfully", true, {collections: collections}, :ok
  end

  def show
    json_response "Collection Loaded Successfully", true, {collection: @collection}, :ok
  end

  def create
    collection = Collection.create(collection_params)
    collection.user_id = current_user.id
    if collection.save
      json_response "Collection created Successfully", true, {collection: collection}, :ok
    else
      json_response "Collection not created", false, {}, :unprocessable_entity
    end
  end

  def update
    if correct_user(@collection.user)
      if @collection.update(collection_params)
        json_response "Collection updated", true, {collection: @collection}, :ok
      else
        json_response "Collection not updated", false, {}, :unprocessable_entity
      end
    else
      json_response "Unauthorized User", false, {}, :unauthorized
    end
  end

  def destroy
    if correct_user @collection.user
      if @collection.destroy
        json_response "Collection delected successfully", true, {collection: @collection}, :ok
      else
        json_response "Collection was not destroyed", false, {}, :unprocessable_entity
      end
    else
      json_response "Unauthorized User", false, {}, :unauthorized
    end
  end

  private
  def load_collection
    @collection = Collection.find_by(id: params[:id])
    if @collection.present?
      return @collection
    else
      json_response "Collection not found", false, {}, :unprocessable_entity
    end
  end

  def collection_params
    params.require(:collection).permit(:title, :body)
  end

end
