class FavoritesController < ApplicationController

  def index
    @favorites = Favorite.all
  end

  def show
  end

  def create
    favorite = current_user.favorites.create(post_id: params[:post_id])
    redirect_to posts_path, notice: "#{favorite.post.user.name}さんのブログをお気に入り登録しました"
  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
    redirect_to favorites_path, notice: "お気に入りを解除しました"
  end
end
