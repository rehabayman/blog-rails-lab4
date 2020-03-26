class CommentsController < ApplicationController
  before_action :auth
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def auth
    p "session is: #{session}"
    redirect_to root_path unless session[:user_id]
  end
  
  # GET /comments
  # GET /comments.json
  def index
    # @comments = Comment.all
    @posts = Post.where(user_id: session[:user_id]).order(created_at: :desc)
    redirect_to posts_path
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    @post_id = params[:post_id]
    @info = [comment: @comment, post_id: @post_id]
  end

  # GET /comments/1/edit
  def edit
    @post_id = params[:post_id]
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.post_id = params[:post_id]
    @comment.user_id = session[:user_id]

    respond_to do |format|
      if @comment.save
        format.html { redirect_to "/posts/#{params[:post_id]}", notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        @post_id = params[:post_id]
        @info = [comment: @comment, post_id: @post_id]
        format.html { render :new , info: @info}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to "/posts/#{params[:post_id]}", notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    p params
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to "/posts/#{params[:post_id]}", notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, params[:post_id])
    end
end
