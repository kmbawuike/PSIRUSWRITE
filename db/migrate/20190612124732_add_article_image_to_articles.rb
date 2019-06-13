class AddArticleImageToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :article_image, :string
  end
end
