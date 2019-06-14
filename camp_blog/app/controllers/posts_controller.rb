class PostsController < ApplicationController
  before_action :set_ranking_data


  def index
    @posts = Post.all.order(created_at: 'desc')
  end

  def show
    @post = Post.find(params[:id])
    REDIS.zincrby "posts/daily/#{Date.today.to_s}", 1, "#{@post.id}"
    @daily_pageviews = REDIS.get "posts/daily/#{Date.today.to_s}/#{@post.id}"

    #@user = User.find_by(id: @post.user_id)
  end

  def new
  end

  def create
    @post = Post.new(params.require(:post).permit(:title, :body).merge(user_id: current_user.id))
    @post.save

    #@post.user_id = current_user.email #
    #@post.user_id = current_user.email
    #@post = Post.new(user_id: current_user.email)


    redirect_to posts_path
  end

  def edit
      @post = Post.find(params[:id])
    if @post.user_id != current_user.id
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(params.require(:post).permit(:title, :body))
      redirect_to posts_path
    else
      render 'edit'
    end
  end


  def destroy
    #if current_user.email == @post.user_id
      @post = Post.find(params[:id])
    if @post.user_id != current_user.id
      redirect_to posts_path
    else
      @post.destroy
      redirect_to posts_path
    end
    #else
      #redirect_to posts_path
    #end
  end

  def set_ranking_data
    #５件のランキングデータを取得
    ids = REDIS.zrevrangebyscore "posts/daily/#{Date.today.to_s}", "+inf", 0, limit: [0, 5]
    @ranking_posts = Post.where(id: ids)

     #５件未満の場合、公開日時順で値を取得
    #if @ranking_posts.count < 5
      #adding_posts = Post.order(publish_time: :DESC, updated_at: :DESC).where.not(id: ids).limit(5 - @ranking_posts.count)
      #@ranking_posts.concat(adding_posts)
    #end
  end


end
