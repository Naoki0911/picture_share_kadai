class UsersController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        redirect_to new_session_path
      else
        render :new
      end
    end
  
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      redirect_to posts_path
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path, notice: "プロフィールを編集しました！"
    else
      flash.now[:danger] = "プロフィールを更新できませんでした"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end

  def ensure_correct_user
    @user = User.find_by(id: params[:id])
    if @user.id != current_user.id
      # ここでいきなりcurrent_userを使えるのは、sessions_helperがapplication_controllerにincludeされているから
      flash[:notice] = "権限がありません"
      redirect_to pictures_path
    end
  end
end
