class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.all
  end

  def show
    @favorite = current_user.favorites.find_by(post_id: @post.id)
    #現在ログインしているユーザーがお気に入り登録している全レコード（user_idとblog_idの入ったFavoriteのレコード)の中にこのブログのidが存在していれば（このブログがお気に入りに登録されていれば）、そのFavoriteのレコード（user_idとblog_id）を@favoriteに代入
  end

  def new
    @post = Post.new
  end

  def edit
    unless current_user == @post.user
      redirect_to posts_path
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if params[:back]
      render :new
    end
    respond_to do |format|
      if @post.save
        ContactMailer.contact_mail(@post).deliver_now
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end     
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless current_user == @post.user
      redirect_to posts_path
    else
      @post.destroy

      respond_to do |format|
        format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  def confirm
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    render :new if @post.invalid?
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :image, :user_id, :image_cache)
  end
end
